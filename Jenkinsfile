node {
	// Clean workspace before doing anything
    deleteDir() 

    try {
			
		stage ('Clone') {
			echo 'Cloning...'
			checkout scm
		}
                
        stage ('Build') {
    	    echo 'Building...'
    		script {
        		switch("${env.BRANCH_NAME}") {
        	        case "master":
        		        EdgeProfile="test"
        		        EdgeSuffix=""
        				break;
        			case "prod":
        			    EdgeProfile="prod"
        			    EdgeSuffix=""
        				break;
					default:
        			    EdgeProfile="test"
        			    EdgeSuffix="/${env.BRANCH_NAME}"
        				break;
        	    }
    	    }
    			withCredentials(
                    [
                      [$class: 'UsernamePasswordMultiBinding',
                       credentialsId: 'rgonzalez-apigee',
                       passwordVariable: 'APIGEE_PASSWORD',
                       usernameVariable: 'APIGEE_USERNAME']
                    ]
                ) {
					docker.image('rgonzalez01/apigee-cicd-base-image:latest').inside {
					sh "mvn -P${EdgeProfile} install -Dusername=${APIGEE_USERNAME} -Dpassword=${APIGEE_PASSWORD} -Dorg=gonzalezruben-eval -Ddeployment.suffix=${EdgeSuffix}"
					}
				}
		}
	   
    } catch (err) {
        currentBuild.result = 'FAILED'
        throw err
    }
	
}