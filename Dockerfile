FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    unzip \
    software-properties-common \
    lsb-release \
    gnupg \
    jq \
    python3 \
    python3-pip

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install -y terraform

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Download and install the Azure DevOps agent
RUN mkdir /agent
WORKDIR /agent

# Get the latest release version from GitHub and download the agent
RUN LATEST_VERSION=$(curl --silent "https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest" | jq -r .tag_name) && \
    DOWNLOAD_URL="https://vstsagentpackage.azureedge.net/agent/${LATEST_VERSION}/vsts-agent-linux-x64-${LATEST_VERSION}.tar.gz" && \
    curl -L -o vsts-agent-linux-x64.tar.gz $DOWNLOAD_URL && \
    tar zxvf vsts-agent-linux-x64.tar.gz && \
    rm vsts-agent-linux-x64.tar.gz

# Install agent dependencies
RUN ./bin/installdependencies.sh

# Add a script to configure and run the Azure DevOps agent
COPY start.sh .

RUN chmod +x start.sh

CMD ["./start.sh"]
