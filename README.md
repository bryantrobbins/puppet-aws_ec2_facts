# puppet-aws_ec2_facts
A simple Puppet module for getting EC2 instance properties as Facter facts

Include this module to make a set of custom facts available. Currently aiming for:
* Facts of the form ec2_tag_X=Y, where an instance has tag X set to value Y.

My initial use case for this is to make CloudFormation logical and stack names available to use when including hieradata (and subsequntly
classifying nodes). I am not currently trying to make this module work in other contexts (e.g., preventing execution on non-AWS EC2
instances).
