defmodule ClusterScrape.PageController do
  require Logger
  use ClusterScrape.Web, :controller

  def index(conn, _params) do
    
    render conn, "index.html"
  end

  def scrape(conn, _params) do
    target = "http://um-hi.com/jack/index.php"
    output = case fetch(target) do
               {:ok, sha} -> sha
               {:error, msg} ->
                 _ = Logger.debug "Error scraping URL #{target}: #{msg}"
                 msg
             end
    render conn, "scrape.html", sha: output
  end

  @spec fetch(String.t) :: {:ok|:error, String.t}
  def fetch(target) do
    case HTTPoison.get(target, [], [ ssl: [{:versions, [:'tlsv1.2']}] ]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, :crypto.hash(:sha256, body) |> Base.encode16}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "URL Not Found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
      _ ->
        {:error, "Other failure"}
    end
  end
end
