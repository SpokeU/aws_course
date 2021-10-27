aws dynamodb list-tables --region us-west-2

aws dynamodb put-item --table-name "vehicles" --item '{"id": {"N": "1"}, "name": {"S": "Audi A8"}, "price": {"N": "100000"}}' --region us-west-2
aws dynamodb put-item --table-name "vehicles" --item '{"id": {"N": "2"}, "name": {"S": "Nissan 350Z"}, "price": {"N": "2147483647"}}' --region us-west-2

aws dynamodb get-item --table-name "vehicles" --key '{"id": {"N": "1"}}' --region us-west-2
aws dynamodb get-item --table-name "vehicles" --key '{"id": {"N": "2"}}' --region us-west-2