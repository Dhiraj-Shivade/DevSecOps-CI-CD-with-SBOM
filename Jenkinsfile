pipeline {
    agent any

    tools{
        maven 'maven3'
    }
    
    environment{
        SCANNER_HOME = tool 'sonar-scanner'
    }
    
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Dhiraj-Shivade/Multi-Tier-DevSecOps-CI-CD.git'
            }
        }
        
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        
        stage('Tests') {
            steps {
                sh "mvn test"
            }
        }
        
        stage('Trivy FS Scan') {
            steps {
                sh "trivy fs --format table > fs.txt ."
            }
        }
        
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=bankapp -Dsonar.projectName=bankapp \
                        -Dsonar.java.binaries=target''' 
                }
            }
        }
        
        stage('Build and Publish to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'proejct-settings', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                        sh "mvn deploy"
                }
            }
        }
        
        stage('Build & Tag Docker Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'Docker-creds') {
                        sh "docker build -t dhirajshivade/bankapp:latest ."
                    }
                }
            }
        }
        
        stage('Trivy Image Scan') {
            steps {
                sh "trivy image dhirajshivade/bankapp:latest > image-scan.txt"
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'Docker-creds') {
                        sh "docker push dhirajshivade/bankapp:latest"
                    }
                }
            }
        }
        
        stage('Generate SBOM using Syft') {
            steps {
                sh "syft dhirajshivade/bankapp:latest -o cyclonedx-json > sbom.json"
            }
        }
        
        stage('Upload SBOM to Dependency-Track using Syft') {
            steps {
                sh '''
                curl -X "POST" "http://13.233.124.11:8080/bank-project-SBOM/" \
                -H "Content-Type: application/json" \
                -H "X-Api-Key: ${DEPENDENCY_TRACK_API_KEY}" \
                --data-binary @sbom.json
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'project-cluster', contextName: '', credentialsId: 'k8s-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://A9B7B32374734BEEF71EA1F863A8AAF7.gr7.ap-south-1.eks.amazonaws.com') {
                    sh "kubectl apply -f manifests.yml -n webapps"
                    sleep 30
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'project-cluster', contextName: '', credentialsId: 'k8s-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://A9B7B32374734BEEF71EA1F863A8AAF7.gr7.ap-south-1.eks.amazonaws.com') {
                    sh "kubectl get svc -n webapps"
                }
            }
        }
    }
}
