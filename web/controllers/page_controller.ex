defmodule ClusterScrape.PageController do
  use ClusterScrape.Web, :controller

  def index(conn, _params) do
    
    render conn, "index.html"
  end

  def scrape(conn, _params) do
    target = "http://um-hi.com/jack/index.php"
    output = case HTTPoison.get(target, [], [ ssl: [{:versions, [:'tlsv1.2']}] ]) do
               {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                 :crypto.hash(:sha256, body) |> Base.encode16
               {:ok, %HTTPoison.Response{status_code: 404}} ->
                 "NOPE"
               {:error, %HTTPoison.Error{reason: reason}} ->
                 "BOOP"
               _ -> "AYYYY"
             end
    render conn, "scrape.html", sha: output
  end
end
