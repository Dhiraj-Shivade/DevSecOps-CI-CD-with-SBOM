# DevSecOps CI/CD Pipeline with SBOM Generation

This repository contains a **DevSecOps CI/CD pipeline** that automates the build, security scanning, and deployment of a multi-tier application to an **Amazon EKS (Elastic Kubernetes Service)** cluster. The pipeline integrates various tools like **Jenkins**, **Trivy**, **Syft**, **SonarQube**, **Nexus**, and **Dependency-Track** to ensure secure and efficient software delivery.

## Architecture Diagram
![image](https://github.com/user-attachments/assets/3b87569d-c40f-48e7-a0b6-0cf4f7cb0b9d)


## Tools Used

### 1. **Jenkins**
   - **Purpose**: Jenkins is used as the CI/CD orchestration tool to automate the pipeline stages.
   - **Why Used**: Jenkins provides flexibility, extensibility, and a rich plugin ecosystem to integrate various tools and services.

### 2. **Maven**
   - **Purpose**: Maven is used for compiling, testing, and packaging the application.
   - **Why Used**: Maven simplifies dependency management and build processes for Java-based applications.

### 3. **Trivy**
   - **Purpose**: Trivy is used for scanning filesystems and container images for vulnerabilities.
   - **Why Used**: Trivy is lightweight, easy to use, and provides comprehensive vulnerability reports.

### 4. **Syft**
   - **Purpose**: Syft is used to generate SBOMs in CycloneDX format.
   - **Why Used**: SBOMs are essential for tracking dependencies and identifying vulnerabilities in software components.

### 5. **SonarQube**
   - **Purpose**: SonarQube is used for static code analysis to detect code smells, bugs, and security vulnerabilities.
   - **Why Used**: SonarQube helps maintain code quality and security throughout the development lifecycle.

### 6. **Nexus**
   - **Purpose**: Nexus is used as a repository manager to store build artifacts.
   - **Why Used**: Nexus ensures secure and efficient storage and retrieval of build artifacts.

### 7. **Dependency-Track**
   - **Purpose**: Dependency-Track is used to analyze and track vulnerabilities in dependencies using SBOMs.
   - **Why Used**: It provides continuous monitoring and alerts for vulnerabilities in third-party components.

### 8. **Docker**
   - **Purpose**: Docker is used to build and push container images.
   - **Why Used**: Docker enables consistent and portable deployment across environments.

### 9. **Kubernetes (EKS)**
   - **Purpose**: Kubernetes is used to deploy and manage the application in a scalable and resilient manner.
   - **Why Used**: EKS simplifies Kubernetes cluster management on AWS.

## Infrastructure
The following AWS EC2 instances are used:
1. **Terraform Server**: Provisions EKS cluster.
2. **Jenkins Server**: Runs CI/CD pipeline with Trivy & Syft.
3. **SonarQube Server**: Performs static code analysis.
4. **Nexus Repository**: Stores build artifacts.
5. **Dependency-Track Server**: Monitors software dependencies.
6. **EKS Cluster (t2.large)**: Hosts containerized applications.

## Jenkins Pipeline Stages

1. **Git Checkout**: Clones the repository from GitHub.
2. **Compile**: Compiles the source code using Maven.
3. **Tests**: Runs unit tests using Maven.
4. **Trivy FS Scan**: Scans the filesystem for vulnerabilities using Trivy.
5. **SonarQube Analysis**: Performs static code analysis using SonarQube.
6. **Build and Publish to Nexus**: Builds the application and publishes artifacts to Nexus.
7. **Build & Tag Docker Image**: Builds and tags a Docker image.
8. **Trivy Image Scan**: Scans the Docker image for vulnerabilities using Trivy.
9. **Push Docker Image**: Pushes the Docker image to a container registry.
10. **Generate SBOM using Syft**: Generates an SBOM for the Docker image using Syft.
11. **Upload SBOM to Dependency-Track**: Uploads the SBOM to Dependency-Track for vulnerability analysis.
12. **Deploy to EKS**: Deploys the application to the EKS cluster.
13. **Verify Deployment**: Verifies the deployment by checking Kubernetes services.

## Installation Guide

### Prerequisites
- AWS account with IAM permissions
- EC2 instances with Ubuntu Server 24.04 LTS
- GitHub repository
- Docker and Kubernetes installed on Jenkins

### Install Jenkins & Required Plugins
```bash
sudo apt update && sudo apt install -y openjdk-11-jdk
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc
sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update && sudo apt install -y jenkins
sudo systemctl start jenkins && sudo systemctl enable jenkins
```
**Required Plugins:**
- Pipeline
- Kubernetes CLI
- Docker Pipeline
- SonarQube Scanner
- Nexus Artifact Uploader
- Jenkins: stage view
- Maven integration

### Install Terraform and provision infrastructure
```bash
wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
unzip terraform_1.5.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```
- Use Terraform to provision the EKS cluster on the terraform server
   terraform init
   terraform plan
   terraform validate
   terraform apply
   terraform destroy
  
### Install Trivy & Syft
```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sudo sh -s -- -b /usr/local/bin
```

### Install SonarQube
```bash
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.zip
unzip sonarqube-9.9.0.zip
sudo mv sonarqube-9.9.0 /opt/sonarqube
sudo adduser sonar
sudo chown -R sonar:sonar /opt/sonarqube
```

### Install Nexus
```bash
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
tar -xvzf latest-unix.tar.gz
sudo mv nexus-3.* /opt/nexus
```

### Install Dependency-Track
```bash
wget https://github.com/DependencyTrack/dependency-track/releases/download/latest/dependency-track-embedded.war
java -jar dependency-track-embedded.war
```

## Security Best Practices
- **Use IAM roles(Least Privilege)**: Apply least privilege principle.
- **Enable TLS encryption**: Encrypt communication between services.
- **Rotate credentials**: Use secrets management solutions.
- **Regular security scanning**: Use Trivy, SonarQube, and Dependency-Track.
- **Network security**: Restrict access using AWS Security Groups and VPC.
- **Logging & Monitoring**: Enable AWS CloudWatch and Kubernetes logs.
- **SBOM Generation**: Generate and monitor SBOMs to track vulnerabilities in dependencies.
- **Regular Updates**: Keep all tools and dependencies updated to the latest versions to avoid known vulnerabilities.

## Conclusion
This project provides a full-fledged DevSecOps pipeline integrating security at every stage of the CI/CD process. It enhances security, automates deployment, and ensures high availability of applications in a Kubernetes cluster.

---

**Author:** Dhiraj Shivade  
**GitHub:** [Dhiraj-Shivade](https://github.com/Dhiraj-Shivade/Multi-Tier-DevSecOps-CI-CD)
