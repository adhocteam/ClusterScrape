defmodule ClusterScrape.PageController do
  require Logger
  use ClusterScrape.Web, :controller

  def index(conn, _params) do
    
    render conn, "index.html"
  end

  def scrape(conn, %{"scrape" => %{"list" => list}}) do
    targets = ["http://um-hi.com/jack/index.php"]
    output = fetch_batch(Enum.map(String.split(list, ","), &String.trim/1))
    render conn, "scrape.html", shas: output, node_list: Enum.map_join(Node.list, " | ", &Atom.to_string/1)
  end

  def fetch_batch(targets) do
    input = Enum.map(targets, fn(target) ->
      {ClusterScrape.PageController, :fetch, [target]}
    end)
    Enum.map(:rpc.parallel_eval(input), fn(req) ->
      case req do
        {:ok, target, sha} -> {target, sha}
        {:error, target, msg} ->
          _ = Logger.debug "Error scraping URL: #{msg}"
          {target, msg}
      end
    end)
  end
  
  @spec fetch(String.t) :: {:ok|:error, String.t}
  def fetch(target) do
    Logger.debug "Scraping on #{Atom.to_string(Node.self)} from #{Enum.map_join(Node.list, " | ", &Atom.to_string/1)}"
    case HTTPoison.get(target, [], [ ssl: [{:versions, [:'tlsv1.2']}] ]) do
      # I'm doing something with a pattern match here
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, target, :crypto.hash(:sha256, body) |> Base.encode16}
      [ok: %HTTPoison.Response{status_code: 200, body: body}] ->
        {:ok, target, :crypto.hash(:sha256, body) |> Base.encode16}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, target, "URL Not Found"}
      [ok: %HTTPoison.Response{status_code: 404}] ->
        {:error, target, "URL Not Found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, target, reason}
      _ ->
        {:error, target, "Other failure"}
    end
  end
end
