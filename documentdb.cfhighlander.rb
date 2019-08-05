CfhighlanderTemplate do
  Name 'documentdb'
  Description "documentdb - #{component_version}"

  Parameters do
    ComponentParam 'EnvironmentName', 'dev', isGlobal: true
    ComponentParam 'EnvironmentType', 'development', allowedValues: ['development','production'], isGlobal: true
    ComponentParam 'VPCId', type: 'AWS::EC2::VPC::Id'
    ComponentParam 'SubnetIds'
    ComponentParam 'Snapshot'
    ComponentParam 'InstanceType'
    ComponentParam 'DnsDomain'
    ComponentParam 'KmsKeyId' if defined? kms
  end

  LambdaFunctions 'ssm_custom_resources'
  
end
