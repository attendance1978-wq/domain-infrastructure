# CIS Benchmark Checklist (AWS)

- [ ] Root account MFA enabled
- [ ] CloudTrail enabled in all regions
- [ ] S3 buckets block public access
- [ ] EBS and RDS volumes encrypted
- [ ] KMS key rotation enabled
- [ ] No security group allows 0.0.0.0/0 to port 22 or 3389
- [ ] VPC flow logs enabled
- [ ] IAM password policy enforced
- [ ] Unused credentials disabled (>90 days)
