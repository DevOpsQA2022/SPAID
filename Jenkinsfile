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
                bat "flutter run --no-sound-null-safety -d all"


                 
                bat "flutter build apk --debug"
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
