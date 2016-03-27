Facter.add(:ec2_availability_zone) do
  setcode do
    Facter::Core::Execution.exec('curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone')
  end
end

Facter.add(:aws_region) do
  setcode do
    az = Facter.value(:ec2_availability_zone)
    az[0..-2]
  end
end

Facter.add(:aws_cloudformation_logical_id) do
  setcode do
    instanceid = Facter.value(:ec2_instance_id)
    region = Facter.value(:aws_region)
    command = "aws --region #{region} ec2 describe-tags --filters \"Name=resource-id,Values=#{instanceid}\"  \"Name=key,Values=aws:cloudformation:logical-id\" --output text | cut -f5"
    logical_id = Facter::Core::Execution.exec(command)
    logical_id.downcase
  end
end

Facter.add(:aws_cloudformation_stack_name) do
  setcode do
    instanceid = Facter.value(:ec2_instance_id)
    region = Facter.value(:aws_region)
    command = "aws --region us-east-1 ec2 describe-tags --filters \"Name=resource-id,Values=#{instanceid}\"  \"Name=key,Values=aws:cloudformation:stack-name\" --output text | cut -f5"
    stack_name = Facter::Core::Execution.exec(command)
    stack_name
  end
end

# Get logical resources which are EC2 instances
region = Facter.value(:aws_region)
stackname = Facter.value(:aws_cloudformation_stack_name)
command="aws --region #{region} cloudformation describe-stack-resources --output text --stack-name #{stackname} | cut -f2,5 | grep AWS::EC2::Instance | cut -f1 | xargs echo"
instances = Facter::Core::Execution.exec(command)

# For each ec2 instance, add a fact for its private ip
instances.split(" ").each do |inst|
  factsym="aws_cloudformation_#{inst}_privateip".downcase!.to_sym
  Facter.add(factsym) do
    setcode do
      command = "aws ec2 describe-instances --region us-east-1 --output text --filters \"Name=tag:aws:cloudformation:logical-id,Values=#{inst}\" \"Name=tag:aws:cloudformation:stack-name,Values=#{stackname}\" | grep 'PRIVATEIPADDRESSES' | cut -f3"
      ip = Facter::Core::Execution.exec(command)
      ip
    end
  end
end
