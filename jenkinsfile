 pipeline {
  agent any
  environment {
    TL_URL = "http://localhost/testlink/lib/api/xmlrpc/v1/xmlrpc.php"
    TL_DEVKEY = credentials('testlink-devkey')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Setup Python') {
      steps {
        sh 'python -m venv .venv'
        sh '. .venv/bin/activate && pip install -r requirements.txt'
      }
    }

    stage('Run Robot Tests') {
      steps {
        sh '. .venv/bin/activate && mkdir -p results && robot --outputdir results tests'
      }
      post {
        always {
          robot outputPath: 'results', outputFileName: 'output.xml'
        }
      }
    }

    stage('Update TestLink') {
      steps {
        sh '. .venv/bin/activate && python tools/rf_to_testlink.py'
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'results/**'
    }
  }
}
