# ClusterScrape

## Example app demonstrating Elixir clustering with AWS autoscaling

### Intro
This simple Phoenix app takes a list of urls to scrape, then returns the sha256 of the response for each. It does this by dispatching RPC calls to other instances running the same release using Erlang's `:rpc.parallel_eval/1`. As currently configured, the app will poll the AWS API every 10 seconds to get the list of peer nodes. Node management is handled by a [custom provider](https://github.com/adhocteam/ClusterScrape/blob/master/lib/cluster_scrape/query_nodes.ex) for [Peerage](https://github.com/mrluc/peerage)

### Installation
* Install Erlang and Elixir
* `mix do deps.get,deps.compile`

### Running

```
mix phoenix.server
```

### Deploying to AWS
Copy ops/vars.yml.example to vars.yml and populate with the appropriate values for your environment. Then run:
```
docker build  -t clusterscrape .
docker run -e "AWS_ACCESS_KEY_ID=<ACCESS KEY>" -e "AWS_SECRET_ACCESS_KEY=<SECRET>" clusterscrape:latest
```
The app will run on port 4000 so make sure your load balancer is set up to route traffic appropriately. Ansible's `ec2_asg` has issues provisioning ASGs that work with ALBs, so classic ELBs are recommended for load balancing. You will also need a security group that will allow traffic on ports 4369 and 9100-9110 _between_ app instances

#### Deploy process overview
* A release will be built using [Distillery](https://github.com/bitwalker/distillery)
* An RPM for the app will be built using [fpm](https://github.com/jordansissel/fpm)
* An AMI for the release will be created using [Packer](https://github.com/hashicorp/packer)
* An AWS launch configuration will be created for the release
* The Autoscale group will be updated to use the new launch configuration, and the old instances will be cycled out. The ASG will be created automatically if it is not present.
