## Ansible quickstart guide

0. Install Ansible

    ```
    sudo pip install ansible
    ```

0. Install roles from Ansible Galaxy/GitHub

    ```
    ansible-galaxy install -r requirements.yml
    ```

0. Run plays against Vagrant host

    ####Install Docker

    ```
    ansible-playbook --private-key=~/.vagrant.d/insecure_private_key -u vagrant -i hosts -s docker.yml
    ```

    ####Deploy app
    ```
    ansible-playbook --private-key=~/.vagrant.d/insecure_private_key -u vagrant -i hosts app.yml
    ```
