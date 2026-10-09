# Certificate Renewal

1. Run `ssl/scripts/renew-certs.sh <domain> <email>`.
2. Reload nginx: `ansible-playbook ansible/playbooks/webservers.yml --tags nginx`.
3. Verify: `echo | openssl s_client -connect <domain>:443 | openssl x509 -noout -dates`.
