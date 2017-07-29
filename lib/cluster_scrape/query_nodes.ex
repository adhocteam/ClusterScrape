defmodule ClusterScrape.QueryNodes do

  def poll do
    # Get the list of running instances that match this release
    {:ok, %{body: body}} =
      ExAws.EC2.describe_instances(filters: ["tag:csrelease": System.get_env("RELEASE_HASH"), "instance-state-code": 16])
      |> ExAws.request
    
    {doc, _} =
      body
      |> :binary.bin_to_list
      |> :xmerl_scan.string

    # Extract the hostnames of the instances
    chunks = :xmerl_xpath.string('/DescribeInstancesResponse/reservationSet/item/instancesSet/item/privateDnsName/text()', doc)
    Enum.map(chunks, fn({:xmlText, _, _, _, thing, :text}) ->
      String.to_atom("node@" <> to_string(thing))
    end)
  end
  
end
