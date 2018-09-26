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
        		        EdgeName=""
        				break;
        			case "prod":
        			    EdgeProfile="prod"
        			    EdgeName=""
        				break;
					default:
        			    EdgeProfile="test"
        			    EdgeSuffix="${env.BRANCH_NAME}"
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
					sh "mvn -P${EdgeProfile} install -Dusername=${APIGEE_USERNAME} -Dpassword=${APIGEE_PASSWORD} -Dorg=gonzalezruben-eval"
				}
		}
	   
    } catch (err) {
        currentBuild.result = 'FAILED'
        throw err
    }
	
}