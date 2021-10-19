aws s3api create-bucket --bucket omyshkoweek2bucket --region us-west-2 --acl private --create-bucket-configuration LocationConstraint=us-west-2
aws s3api put-bucket-versioning --bucket omyshkoweek2bucket --versioning-configuration Status=Enabled
aws s3api put-public-access-block --bucket omyshkoweek2bucket --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

aws s3 cp helloworld.txt s3://omyshkoweek2bucket
