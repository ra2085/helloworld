def label = "apigee-cicd-${UUID.randomUUID().toString()}"
podTemplate(label: label, containers: [
    containerTemplate(name: 'apigee-cicd-base-image', image: 'rgonzalez01/apigee-cicd-base-image', ttyEnabled: true, command: 'cat')
  ]) {
node(label) {
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
					container('apigee-cicd-base-image') {
						sh "mvn -P${EdgeProfile} install -Dusername=${APIGEE_USERNAME} -Dpassword=${APIGEE_PASSWORD} -Dorg=gonzalezruben-eval -Ddeployment.suffix=${EdgeSuffix}"
					}
				}
		}
		stage('Functional Test Report') {
                step([
                    $class: 'CucumberReportPublisher',
                    fileExcludePattern: '',
                    fileIncludePattern: "**/reports.json",
                    ignoreFailedTests: false,
                    jenkinsBasePath: '',
                    jsonReportDirectory: "target",
                    missingFails: false,
                    parallelTesting: false,
                    pendingFails: false,
                    skippedFails: false,
                    undefinedFails: false
                    ])
        }
	   
    } catch (err) {
        currentBuild.result = 'FAILED'
        throw err
    }
	
}
}