library(
    identifier: 'pipeline-lib@smrt-817',
    retriever: modernSCM([$class: 'GitSCMSource',
                          remote: 'https://github.com/SmartColumbusOS/pipeline-lib',
                          credentialsId: 'jenkins-github-user'])
)

properties(
    [
        pipelineTriggers([scos.dailyBuildTrigger()]),
        disableConcurrentBuilds(),
    ]
)

node('infrastructure') { ansiColor('xterm') { sshagent(["k8s-no-pass", "GitHub"]) { withCredentials([
    [
        $class: 'AmazonWebServicesCredentialsBinding',
        credentialsId: 'aws_jenkins_user',
        variable: 'AWS_ACCESS_KEY_ID'
    ],
    sshUserPrivateKey(
        credentialsId: "k8s-no-pass",
        keyFileVariable: 'keyfile'
    )
]) {
    String publicKey

    scos.doCheckoutStage()

    stage('Setup SSH keys') {
        publicKey = sh(returnStdout: true, script: "ssh-keygen -y -f ${keyfile}").trim()
    }

    def terraform = scos.terraform('alm')

    stage("Plan ALM") {
        terraform.init()

        def overrides = [:]
        overrides << [ 'key_pair_public_key': publicKey ]

        terraform.plan(terraform.defaultVarFile, overrides)

        archiveArtifacts artifacts: 'plan-*.txt', allowEmptyArchive: false
    }
}}}}
