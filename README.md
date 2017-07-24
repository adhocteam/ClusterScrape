# ClusterScrape

Ad Hoc Sabbatical Project - Mike Auclair

Intro:
Elixir, the programming language based on Erlang’s BEAM VM has exploded in popularity. It combines comprehensible Ruby-like syntax with the clustering abilities and fault tolerance of the BEAM VM. One of the major value propositions of BEAM is its baked-in clustering abilities. A process started on one machine can easily be sharded across multiple machines, with little work by the programmer, and inherent fault-tolerance and sane retry semantics. How does BEAM service discovery interplay with AWS Autoscaling? Could this deliver tangible value to our processes given the ephemeral nature of our instances?

Proposal:
Build a thin Elixir webapp that receives a set of URLs from the client and scrapes them on multiple machines. Use packer + ansible to build an AMI with the app baked on intended to be delivered into an autoscale group.
