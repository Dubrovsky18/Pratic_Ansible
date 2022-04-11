vagrant up
ansible-playbook consul.play
ansible consul -m shell -a 'sudo systemctl restart consul'
ansible-playbook playbook.yml

