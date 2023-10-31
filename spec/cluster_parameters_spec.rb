require 'yaml'

describe 'compiled component documentdb' do
  
  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/cluster_parameters.test.yaml")).to be_truthy
    end      
  end
  
  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/cluster_parameters/documentdb.compiled.yaml") }
  
  context "Resource" do

    
    context "SSMSecureParameter" do
      let(:resource) { template["Resources"]["SSMSecureParameter"] }

      it "is of type Custom::SSMSecureParameter" do
          expect(resource["Type"]).to eq("Custom::SSMSecureParameter")
      end
      
      it "to have property ServiceToken" do
          expect(resource["Properties"]["ServiceToken"]).to eq({"Fn::GetAtt"=>["SSMSecureParameterCR", "Arn"]})
      end
      
      it "to have property Length" do
          expect(resource["Properties"]["Length"]).to eq(32)
      end
      
      it "to have property Path" do
          expect(resource["Properties"]["Path"]).to eq({"Fn::Sub"=>"/documentdb/${EnvironmentName}/password"})
      end
      
      it "to have property Description" do
          expect(resource["Properties"]["Description"]).to eq({"Fn::Sub"=>"${EnvironmentName} DocumentDB Password"})
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Name", "Value"=>{"Fn::Sub"=>"${EnvironmentName}-documentdb-password"}}, {"Key"=>"Environment", "Value"=>{"Fn::Sub"=>"${EnvironmentName}"}}, {"Key"=>"EnvironmentType", "Value"=>{"Fn::Sub"=>"${EnvironmentType}"}}])
      end
      
    end
    
    context "ParameterSecretKey" do
      let(:resource) { template["Resources"]["ParameterSecretKey"] }

      it "is of type AWS::SSM::Parameter" do
          expect(resource["Type"]).to eq("AWS::SSM::Parameter")
      end
      
      it "to have property Name" do
          expect(resource["Properties"]["Name"]).to eq({"Fn::Sub"=>"/documentdb/${EnvironmentName}/username"})
      end
      
      it "to have property Type" do
          expect(resource["Properties"]["Type"]).to eq("String")
      end
      
      it "to have property Value" do
          expect(resource["Properties"]["Value"]).to eq("master")
      end
      
    end
    
    context "DocDBSecurityGroup" do
      let(:resource) { template["Resources"]["DocDBSecurityGroup"] }

      it "is of type AWS::EC2::SecurityGroup" do
          expect(resource["Type"]).to eq("AWS::EC2::SecurityGroup")
      end
      
      it "to have property VpcId" do
          expect(resource["Properties"]["VpcId"]).to eq({"Ref"=>"VPCId"})
      end
      
      it "to have property GroupDescription" do
          expect(resource["Properties"]["GroupDescription"]).to eq("DocumentDB communication")
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Name", "Value"=>{"Fn::Sub"=>"${EnvironmentName}-documentdb"}}])
      end
      
    end
    
    context "DocDBSubnetGroup" do
      let(:resource) { template["Resources"]["DocDBSubnetGroup"] }

      it "is of type AWS::DocDB::DBSubnetGroup" do
          expect(resource["Type"]).to eq("AWS::DocDB::DBSubnetGroup")
      end
      
      it "to have property DBSubnetGroupDescription" do
          expect(resource["Properties"]["DBSubnetGroupDescription"]).to eq({"Fn::Sub"=>"${EnvironmentName} documentdb"})
      end
      
      it "to have property SubnetIds" do
          expect(resource["Properties"]["SubnetIds"]).to eq({"Fn::Split"=>[",", {"Ref"=>"SubnetIds"}]})
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Name", "Value"=>{"Fn::Sub"=>"${EnvironmentName}-documentdb-subnet-group"}}])
      end
      
    end
    
    context "DocDBCluster" do
      let(:resource) { template["Resources"]["DocDBCluster"] }

      it "is of type AWS::DocDB::DBCluster" do
          expect(resource["Type"]).to eq("AWS::DocDB::DBCluster")
      end
      
      it "to have property DBClusterParameterGroupName" do
          expect(resource["Properties"]["DBClusterParameterGroupName"]).to eq({"Ref"=>"DocDBClusterParameterGroup"})
      end
      
      it "to have property DBSubnetGroupName" do
          expect(resource["Properties"]["DBSubnetGroupName"]).to eq({"Ref"=>"DocDBSubnetGroup"})
      end
      
      it "to have property VpcSecurityGroupIds" do
          expect(resource["Properties"]["VpcSecurityGroupIds"]).to eq([{"Ref"=>"DocDBSecurityGroup"}])
      end
      
      it "to have property SnapshotIdentifier" do
          expect(resource["Properties"]["SnapshotIdentifier"]).to eq({"Ref"=>"Snapshot"})
      end
      
      it "to have property MasterUsername" do
          expect(resource["Properties"]["MasterUsername"]).to eq("master")
      end
      
      it "to have property MasterUserPassword" do
          expect(resource["Properties"]["MasterUserPassword"]).to eq({"Fn::GetAtt"=>["SSMSecureParameter", "Password"]})
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Name", "Value"=>{"Fn::Sub"=>"${EnvironmentName}-documentdb-cluster"}}])
      end
      
    end
    
    context "DocDBClusterParameterGroup" do
      let(:resource) { template["Resources"]["DocDBClusterParameterGroup"] }

      it "is of type AWS::DocDB::DBClusterParameterGroup" do
          expect(resource["Type"]).to eq("AWS::DocDB::DBClusterParameterGroup")
      end
      
      it "to have property Description" do
          expect(resource["Properties"]["Description"]).to eq("Parameter group for the documentdb cluster")
      end
      
      it "to have property Family" do
          expect(resource["Properties"]["Family"]).to eq("docdb3.6")
      end
      
      it "to have property Name" do
          expect(resource["Properties"]["Name"]).to eq({"Fn::Sub"=>"${EnvironmentName}-documentdb-cluster-parameter-group"})
      end
      
      it "to have property Parameters" do
          expect(resource["Properties"]["Parameters"]).to eq({"audit_logs"=>"disabled", "profiler"=>"disabled", "profiler_sampling_rate"=>1.0, "profiler_threshold_ms"=>100, "tls"=>"enabled", "ttl_monitor"=>"enabled"})
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Name", "Value"=>{"Fn::Sub"=>"${EnvironmentName}-documentdb-cluster-parameter-group"}}])
      end
      
    end
    
    context "DocDBInstanceA" do
      let(:resource) { template["Resources"]["DocDBInstanceA"] }

      it "is of type AWS::DocDB::DBInstance" do
          expect(resource["Type"]).to eq("AWS::DocDB::DBInstance")
      end
      
      it "to have property DBClusterIdentifier" do
          expect(resource["Properties"]["DBClusterIdentifier"]).to eq({"Ref"=>"DocDBCluster"})
      end
      
      it "to have property DBInstanceClass" do
          expect(resource["Properties"]["DBInstanceClass"]).to eq({"Ref"=>"InstanceType"})
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Name", "Value"=>{"Fn::Sub"=>"${EnvironmentName}-documentdb-instance-A"}}])
      end
      
    end
    
    context "DBHostRecord" do
      let(:resource) { template["Resources"]["DBHostRecord"] }

      it "is of type AWS::Route53::RecordSet" do
          expect(resource["Type"]).to eq("AWS::Route53::RecordSet")
      end
      
      it "to have property HostedZoneName" do
          expect(resource["Properties"]["HostedZoneName"]).to eq({"Fn::Join"=>["", [{"Ref"=>"EnvironmentName"}, ".", {"Ref"=>"DnsDomain"}, "."]]})
      end
      
      it "to have property Name" do
          expect(resource["Properties"]["Name"]).to eq({"Fn::Join"=>["", ["docdb", ".", {"Ref"=>"EnvironmentName"}, ".", {"Ref"=>"DnsDomain"}, "."]]})
      end
      
      it "to have property Type" do
          expect(resource["Properties"]["Type"]).to eq("CNAME")
      end
      
      it "to have property TTL" do
          expect(resource["Properties"]["TTL"]).to eq("60")
      end
      
      it "to have property ResourceRecords" do
          expect(resource["Properties"]["ResourceRecords"]).to eq([{"Fn::GetAtt"=>["DocDBCluster", "Endpoint"]}])
      end
      
    end
    
    context "LambdaRoleSSMParameterCustomResource" do
      let(:resource) { template["Resources"]["LambdaRoleSSMParameterCustomResource"] }

      it "is of type AWS::IAM::Role" do
          expect(resource["Type"]).to eq("AWS::IAM::Role")
      end
      
      it "to have property AssumeRolePolicyDocument" do
          expect(resource["Properties"]["AssumeRolePolicyDocument"]).to eq({"Version"=>"2012-10-17", "Statement"=>[{"Effect"=>"Allow", "Principal"=>{"Service"=>"lambda.amazonaws.com"}, "Action"=>"sts:AssumeRole"}]})
      end
      
      it "to have property Path" do
          expect(resource["Properties"]["Path"]).to eq("/")
      end
      
      it "to have property Policies" do
          expect(resource["Properties"]["Policies"]).to eq([{"PolicyName"=>"cloudwatch-logs", "PolicyDocument"=>{"Statement"=>[{"Effect"=>"Allow", "Action"=>["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogStreams", "logs:DescribeLogGroups"], "Resource"=>["arn:aws:logs:*:*:*"]}]}}, {"PolicyName"=>"ssm", "PolicyDocument"=>{"Statement"=>[{"Effect"=>"Allow", "Action"=>["ssm:AddTagsToResource", "ssm:DeleteParameter", "ssm:PutParameter", "ssm:GetParameters"], "Resource"=>"*"}]}}])
      end
      
    end
    
    context "SSMSecureParameterCR" do
      let(:resource) { template["Resources"]["SSMSecureParameterCR"] }

      it "is of type AWS::Lambda::Function" do
          expect(resource["Type"]).to eq("AWS::Lambda::Function")
      end
      
      it "to have property Code" do
        expect(resource["Properties"]["Code"]["S3Bucket"]).to eq("")
        expect(resource["Properties"]["Code"]["S3Key"]).to start_with("/latest/SSMSecureParameterCR.documentdb.latest")
      end
      
      it "to have property Environment" do
          expect(resource["Properties"]["Environment"]).to eq({"Variables"=>{}})
      end
      
      it "to have property Handler" do
          expect(resource["Properties"]["Handler"]).to eq("handler.lambda_handler")
      end
      
      it "to have property MemorySize" do
          expect(resource["Properties"]["MemorySize"]).to eq(128)
      end
      
      it "to have property Role" do
          expect(resource["Properties"]["Role"]).to eq({"Fn::GetAtt"=>["LambdaRoleSSMParameterCustomResource", "Arn"]})
      end
      
      it "to have property Runtime" do
          expect(resource["Properties"]["Runtime"]).to eq("python3.11")
      end
      
      it "to have property Timeout" do
          expect(resource["Properties"]["Timeout"]).to eq(5)
      end
      
    end
    
  end

end