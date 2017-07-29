# ClusterScrape

## Example app demonstrating Elixir clustering with AWS autoscaling

### Intro
This simple Phoenix app takes a list of urls to scrape, then returns the sha256 of the response for each. It does this by dispatching RPC calls to other instances running the same release using Erlang's `:rpc.parallel_eval/1`. As currently configured

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
The app will run on port 4000 so make sure your load balancer is set up to route traffic appropriately. Ansible's `ec2_asg` has issues provisioning ASGs that work with ALBs, so classic ELBs are recommended for laod balancing.
