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
                bat """
                "${env.PYTHON}" -m venv venv
                call venv\\Scripts\\activate
                venv\\Scripts\\pip install --upgrade pip
                venv\\Scripts\\pip install -r requirements.txt
                """
            }
        }

        stage('Run Robot Tests') {
            steps {
                bat """
                if not exist results mkdir results
                venv\\Scripts\\robot --outputdir results tests
                """
            }
        }

        stage('Update TestLink') {
            steps {
                bat """
                venv\\Scripts\\python tools\\rf_to_testlink.py
                """
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/**'
        }
    }
}
