resource "aws_dms_replication_instance" "dms-instance" {
  allocated_storage          = 30
  apply_immediately          = true
  auto_minor_version_upgrade = false
  multi_az                   = false
  publicly_accessible        = true
  replication_instance_class = "dms.t3.micro"
  replication_instance_id    = "dms-instance"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.example.id
#  vpc_security_group_ids       = [aws_security_group.dms.id]
 
  tags = {
    Name = "DMS-Replication-Instance"
  }

}



resource "aws_dms_endpoint" "source_endpoint" {
  endpoint_id = "terraform-src"
  endpoint_type       = "source"
  engine_name         = "mysql"
  username            = "admin"
  password            = "yourpassword"
  server_name         = "terraform-src.cgfnjlpo1b2r.eu-west-2.rds.amazonaws.com" # Replace with the source RDS endpoint
  port                = 3306
  extra_connection_attributes = "initstmt=SET FOREIGN_KEY_CHECKS=0;" # Optional: Disable foreign key checks during migration
}

resource "aws_dms_endpoint" "target_endpoint" {
  endpoint_id = "myseconddb"
  endpoint_type       = "target"
  engine_name         = "mysql"
  username            = "admin"
  password            = "2ndpassword"
  server_name         = "myseconddb.cgfnjlpo1b2r.eu-west-2.rds.amazonaws.com" # Replace with the target RDS endpoint
  port                = 3306
}

resource "aws_dms_replication_task" "example_replication_task" {
  replication_task_id             = "example-replication-task"
  migration_type                  = "full-load"
    replication_instance_arn = aws_dms_replication_instance.dms-instance.replication_instance_arn
  source_endpoint_arn      = aws_dms_endpoint.source_endpoint.endpoint_arn
  target_endpoint_arn             = aws_dms_endpoint.target_endpoint.endpoint_arn
  table_mappings                  = <<EOF
{
  "rules": [
    {
      "rule-type": "selection",
      "rule-id": "1",
      "rule-name": "1",
      "object-locator": {
        "schema-name": "OnlineMerchStore",
        "table-name": "%"
      },
      "rule-action": "include",
      "rule-action": "include"
    }
  ]
}
EOF
}

