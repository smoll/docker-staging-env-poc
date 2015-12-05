## Ansible quickstart guide

0. Install Ansible

    ```
    sudo pip install ansible
    ```

0. Install roles from Ansible Galaxy/GitHub

    ```
    sudo ansible-galaxy install -r requirements.yml
    ```

0. Run plays against Vagrant host

    ####Install Docker

    ```
    ansible-playbook --private-key=~/.vagrant.d/insecure_private_key -u vagrant -i hosts -s docker.yml
    ```

    (note the `-s` for sudo)

    ####Deploy app

    ```
    ansible-playbook --private-key=~/.vagrant.d/insecure_private_key -u vagrant -i hosts app.yml
    ```
