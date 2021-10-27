aws s3api create-bucket --bucket omyshkoweek3bucket --region us-west-2 --acl private --create-bucket-configuration LocationConstraint=us-west-2
aws s3api put-bucket-versioning --bucket omyshkoweek3bucket --versioning-configuration Status=Enabled
aws s3api put-public-access-block --bucket omyshkoweek3bucket --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

aws s3 cp rds-script.sql s3://omyshkoweek3bucket
aws s3 cp dynamodb-script.sh s3://omyshkoweek3bucket
