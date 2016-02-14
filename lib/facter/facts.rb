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
