## Terraform
Create a terraform resource:

* Create a VPC with 1 private and 1 public subnet (use this cidr block: 10.0.0.0/16)
* Create an Internet Gateway for this new VPC
* Create IAM role and policy that has a put object to an s3 bucket.
* Create an ec2 resource in a private subnet and attach the role created from earlier.
* Create RDS instance and....

# AWS
Answer the AWS questions under `aws-exam` folder and put your answers on a separate txt file.


# GIT
- Create a temp branch using this format: `tmp/yourlastname-ddmmyy`
- Commit and push your work to remote repo.
- PR to exam branch and request for review.

# GIT Branching Strategy Technical Exam
### Scenario
Code changes has been pushed to master

### Exam
- You have verified that there are no code changes in teamx-develop branch. Do the necessary action/s to sync it with master.
- You have verified that there are code changes in teamx-rc-ready branch. Sync teamx-rc-ready branch and ensure that the deployment flow will not get disrupted by this branch reset/rebase.
- Update tmp/gasataya-290524 branch to have only 1 commit (with all the changes included).
