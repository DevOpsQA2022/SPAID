pipeline {
    agent any
     tools{
      gradle 'gradle'
    }
    stages {
        stage('Build') {              
            steps {
                bat "flutter clean"
                bat "flutter pub get"                                
                bat "flutter build apk --debug"
                bat "flutter run -d chrome --no-sound-null-safety"
                echo "successfully build"
                
            }
              post{
                 success{
                     echo "Archiving the Artifacts"
                     archiveArtifacts artifacts: '**/debug/*.apk'
                    
                 }
            }            
        }
    }
}
