pipeline {
    agent any
     tools{
      gradle 'gradle'
    }
    stages {
        stage('Build') {              
            steps {
                bat "flutter clean"
                bat "git config --global --add safe.directory C:/Users/manjula.r/flutter_windows_3.3.9-stable/flutter"
                bat "flutter pub get"     
                bat "flutter build apk --flavor dev -t lib/main_dev.dart --no-sound-null-safety"
                bat "flutter build web -t lib/main_dev.dart --no-sound-null-safety"
                //                 bat "flutter build apk --debug"
//                 bat "flutter run -d chrome --no-sound-null-safety"
                echo "successfully build"
                
            }
              post{
                 success{
                     echo "Archiving the Artifacts"
                     archiveArtifacts artifacts: '**/release/*.apk'
                    
                 }
            }            
        }
    }
}
