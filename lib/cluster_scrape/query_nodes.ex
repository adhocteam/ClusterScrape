defmodule ClusterScrape.QueryNodes do

  def poll do
    {:ok, %{body: body}} =  ExAws.EC2.describe_instances(filters: ["tag:csrelease": "2553e5b", "instance-state-code": 16]) |> ExAws.request
    body |> :binary.bin_to_list |> :xmerl_scan.string
    {doc, _} = body |> :binary.bin_to_list |> :xmerl_scan.string
    chunks = :xmerl_xpath.string('/DescribeInstancesResponse/reservationSet/item/instancesSet/item/privateDnsName/text()', doc)
    Enum.map(chunks, fn(x) ->
      {:xmlText, _, _, _, thing, :text} = x
      String.to_atom("node@" <> to_string(thing))
    end)
  end
  
end
