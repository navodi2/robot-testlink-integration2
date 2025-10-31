 pipeline {
    agent any

    environment {
        TL_URL = "http://localhost/testlink/lib/api/xmlrpc/v1/xmlrpc.php"
        TL_DEVKEY = credentials('testlink-devkey')  // Your TestLink API key stored in Jenkins credentials
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Python') {
            steps {
                echo "Setting up Python virtual environment..."
                // Create venv
                bat 'python -m venv .venv'
                // Install dependencies
                bat '.venv\\Scripts\\pip.exe install --upgrade pip'
                bat '.venv\\Scripts\\pip.exe install -r requirements.txt'
            }
        }

        stage('Run Robot Tests') {
            steps {
                echo "Running Robot Framework tests..."
                // Create results folder
                bat 'if not exist results mkdir results'
                // Run tests
                bat '.venv\\Scripts\\robot.exe --outputdir results tests'
            }
            post {
                always {
                    // Use Robot plugin to publish results (optional if plugin installed)
                    robot outputPath: 'results', outputFileName: 'output.xml'
                }
            }
        }

        stage('Update TestLink') {
            steps {
                echo "Reporting results to TestLink..."
                bat '.venv\\Scripts\\python.exe tools\\rf_to_testlink.py'
            }
        }

    }

    post {
        always {
            echo "Archiving results..."
            archiveArtifacts artifacts: 'results/**'
        }
    }
}
