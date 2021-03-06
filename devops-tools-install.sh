#!/bin/bash
# This script will bootstrap Ubuntu with DevOps related tools

echo " Installing curl git "
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt -y update
sudo apt -y install curl git

# generate ssh keys and add them to ssh agent
# ssh-keygen -t rsa -C 'your_email@mail.com'
# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_rsa

echo " Installing powershell "
wget https://github.com/PowerShell/PowerShell/releases/download/v7.2.1/powershell-lts_7.2.1-1.deb_amd64.deb
sudo dpkg -i powershell-lts_7.2.1-1.deb_amd64.deb
sudo apt-get install -f
pwsh

# install Az module in powershell session
# Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
# Install-Module -Name Az -AllowClobber -Scope CurrentUser
# Update-Help

echo "Installing Node.js 16..."
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs

echo "Installing TypeScript..."
npm install -g typescript
tsc --version

echo "Installing Java 11..."
sudo apt install openjdk-11-jdk -y

echo "Installing Go lang..."
wget https://go.dev/dl/go1.17.5.linux-amd64.tar.gz
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf go1.17.5.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version

echo "Installing Ansible..."
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt -y update
sudo apt -y install ansible

echo "Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "Installing Docker Engine..."
sudo apt install ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt -y install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

echo "Installing the latest Helm..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm ./get_helm.sh

echo "Installing Terraform ..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt -y install terraform

echo "Installing Packer..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt install packer

echo "Installing Postman..."
sudo snap install postman

echo "Installing VS Code, replace settings from GIST backup, use fonts with better view and install extensions."
sudo snap install --classic code
#curl -L "https://gist.github.com/nsticco/1b32f3b0f630df637436e407a8ba626d/raw" -o ~/.config/Code/User/settings.json
git clone https://github.com/lemeb/a-better-ligaturizer.git ~/a-better-ligaturizer
sudo cp -a ~/a-better-ligaturizer/output-fonts/. /usr/share/fonts/truetype/
code --install-extension hashicorp.terraform \
    --install-extension eamodio.gitlens \
    --install-extension golang.go \
    --install-extension ms-azuretools.vscode-bicep \
    --install-extension ms-vscode.powershell \
    --install-extension msazurermtools.azurerm-vscode-tools \
    --install-extension ms-vscode-remote.remote-containers \
    --install-extension ms-kubernetes-tools.vscode-kubernetes-tools

echo " Installing minikube and start local k8s "
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start
kubectl get nodes

echo "Cleaning up after bootstrapping..."
sudo apt -y autoremove
sudo apt -y clean
reboot
