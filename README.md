Once you've created the two databases, the source database and target database using the scripts.
Then initiate the data transfer using the dms folder in the test1 script. first replace name with the target endpoint 
and the source endpoint in dms.tf and also at the iam.tf replace the subnets Ids.
Then cd into the dms folder and run terraform commands

cd dms
dms> terraform init
dms> terraform apply --auto-approve
