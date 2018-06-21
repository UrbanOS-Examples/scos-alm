node('master') {
ansiColor('xterm') {
    stage('Checkout') {
        checkout scm
    }
    
    stage('Deploy') {
        dir('alm') {
            sh('proxy-cluster/deploy.sh')
        }
    }
}
}