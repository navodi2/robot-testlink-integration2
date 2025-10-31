pipeline {
    agent any

    environment {
        TL_URL = "http://localhost/testlink/lib/api/xmlrpc/v1/xmlrpc.php"
        TL_DEVKEY = credentials('testlink-devkey')
        PYTHON = "C:\\Users\\User\\AppData\\Local\\Programs\\Python\\Python312\\python.exe"
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
                bat "${env.PYTHON} -m venv .venv"
                bat ".venv\\Scripts\\pip.exe install --upgrade pip"
                bat ".venv\\Scripts\\pip.exe install -r requirements.txt"
            }
        }

        stage('Run Robot Tests') {
            steps {
                echo "Running Robot Framework tests..."
                bat "if not exist results mkdir results"
                bat ".venv\\Scripts\\robot.exe --outputdir results tests"
            }
        }

        stage('Update TestLink') {
            steps {
                echo "Reporting results to TestLink..."
                bat ".venv\\Scripts\\python.exe tools\\rf_to_testlink.py"
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/**'
        }
    }
}
