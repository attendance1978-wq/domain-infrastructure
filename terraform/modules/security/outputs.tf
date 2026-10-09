output "alb_sg_id"              { value = aws_security_group.alb.id }
output "app_sg_id"              { value = aws_security_group.app.id }
output "db_sg_id"               { value = aws_security_group.db.id }
output "instance_role_arn"      { value = aws_iam_role.instance.arn }
output "instance_profile_name"  { value = aws_iam_instance_profile.instance.name }
output "kms_key_arn"            { value = aws_kms_key.this.arn }
