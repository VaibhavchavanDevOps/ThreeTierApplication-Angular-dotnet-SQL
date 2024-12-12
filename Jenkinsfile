pipeline {
    agent any

	triggers {
        githubPush() // Trigger the pipeline when a push event occurs
    }
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker')
        FRONTEND_IMAGE = 'vaibhavnitor/frontend-image'
        BACKEND_IMAGE = 'vaibhavnitor/backend-image'
        DATABASE_IMAGE = 'vaibhavnitor/database-image'
        // GKE Cluster Details
        GKE_CLUSTER_NAME = 'my-first-cluster-1'
        GKE_ZONE = 'us-central1-c'
        GKE_PROJECT = 'poc-cluster-444406'

    }

    stages {
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/VaibhavchavanDevOps/ThreeTierApplication-Angular-dotnet-SQL.git'
            }
		}

        stage('Build Frontend Docker Image') {
            steps {
                script {
                    //Replace 'frontend' with the path to the frontend Dockerfile
                    sh 'docker  build -t ${FRONTEND_IMAGE}:latest  ElectronicEquipmentAngular'
                }
            }
        }
        stage('Build Database Docker Image') {
          steps {
              script {
                    //Replace 'database' with the path to the database Dockerfile
                 sh 'docker build -t ${DATABASE_IMAGE}:latest .'
                  sh 'docker run -d -p 1433:1433 ${DATABASE_IMAGE}:latest'
                }
            }
	    }

        stage('Build Backend Docker Image') {
            steps {
                script {
                    // Replace 'backend' with the path to the backend Dockerfile
                    sh 'docker  build -t ${BACKEND_IMAGE}:latest  ElectricEquipmentDotNetCoreAPI'
                }
            }
        }
		//stage("TRIVY"){
          //  steps{
            //    sh "trivy image ${FRONTEND_IMAGE}:latest "
			//	sh "trivy image ${BACKEND_IMAGE}:latest "
			//	sh "trivy image ${DATABASE_IMAGE}:latest "
            //}
        //}
        //stage('deploy to container'){
          //  steps{
            //    script{
                        //sh'docker run -d -p 80:80 ${FRONTEND_IMAGE}:latest'
                        //sh'docker run -d -p 81:80 ${BACKEND_IMAGE}:latest'
              //  }
            //}
        //}
        stage('Push Images to Docker Hub') {
            steps {
              script {
                withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
 
                // Push the Docker images
                sh 'docker push ${FRONTEND_IMAGE}:latest'
                sh 'docker push ${BACKEND_IMAGE}:latest'
                sh 'docker push ${DATABASE_IMAGE}:latest'
            }
        }
		}
        }
        stage('Clean Up Docker Containers') {
            steps {
                script {
                    // Stop all running containers
                    sh 'docker stop $(docker ps -q) || true'
                    
                    // Remove all containers, including stopped ones
                    sh 'docker rm $(docker ps -a -q) || true'
                }
            }
        }
        //stage('Install gke-gcloud-auth-plugin') {
          //  steps {
            //    script {
                    // Install gke-gcloud-auth-plugin
              //      sh 'gcloud components install gke-gcloud-auth-plugin'
                //}
            //}
        //}
        stage('Deploy to GKE') {
            steps {
                script {
                    // Authenticate with GKE
                    withCredentials([file(credentialsId: 'gke-credentials', variable: 'GKE_CREDENTIALS')]) {
                        // Authenticate with GCloud
                        sh '''
                            gcloud auth activate-service-account --key-file=${GKE_CREDENTIALS}
                            gcloud config set project ${GKE_PROJECT}
                            gcloud container clusters get-credentials ${GKE_CLUSTER_NAME} --zone ${GKE_ZONE}
                        '''
                        
                        // Deploy to GKE
                        sh '''
                            kubectl apply -f ConfigMap.yaml
                            kubectl apply -f PersistentVolumeClaim.yaml
                            kubectl apply -f secret.yaml
                            kubectl apply -f database-deployment.yaml
                            kubectl apply -f database-service.yaml
                            kubectl apply -f ElectricEquipmentDotNetCoreAPI/backend.yaml
                            kubectl apply -f ElectricEquipmentDotNetCoreAPI/backend-service.yaml
                            kubectl apply -f ElectronicEquipmentAngular/frontend-deployment.yaml
                            kubectl apply -f ElectronicEquipmentAngular/frontend-service.yaml
                            
                        '''
                        
                        // Verify deployments
                        sh '''
                            kubectl get deployments
                            kubectl get services
                            kubectl get pods
                        '''
						}
					}
				}
			}
  }
}
