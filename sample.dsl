pipelineJob('owesome job') {
    definition {
        cps {
            script('''

                node {
                    def mvnHome
                    stage('Checkout') {
                        git 'https://github.com/Macromar/sampleMaven.git'
                    }
                    stage ('setup tools'){
                        mvnHome = tool 'M3'
                    }
                    stage('Build') {
                        withEnv(["MVN_HOME=$mvnHome"]) {
                            if (isUnix()) {
                                sh '"$MVN_HOME/bin/mvn" -Dmaven.test.failure.ignore clean package'
                            } else {
                                sh "exit 1"
                            }
                        }
                    }
                    stage('Results') {
                        junit '**/target/surefire-reports/TEST-*.xml'
                        archiveArtifacts 'target/*.jar'
                    }
                }
            ''')
                        sandbox()
                    }
                }
            }