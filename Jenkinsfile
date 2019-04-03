def label = "jenkins-agent-pod-${UUID.randomUUID().toString()}"

podTemplate(label: label,
    containers: [
        containerTemplate(name: 'k8s-tools', image: 'jobteaser/k8s-tools',
                resourceRequestCpu: '200m', resourceLimitCpu: '400m',
                resourceRequestMemory: '256Mi', resourceLimitMemory: '512Mi',
                ttyEnabled: true, command: 'cat')
    ]
) {
    node(label) {
        stage('Checkout git source') {
            checkout scm

            def scmUrl = sh(returnStdout: true, script: 'git config remote.origin.url').trim()
            checkout([
                $class: 'GitSCM', branches: [[name: '*/' + GIT_TARGET_BRANCH]],
                userRemoteConfigs: [[url: scmUrl, credentialsId: GIT_CREDENTIAL_ID]],
                extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'docs']],
                gitTool: 'Default'
            ])
        }
        stage('Checking chart updates') {
            updatedDirs = sh(returnStdout: true, script: "git diff --name-only HEAD^ | grep / | cut -d/ -f1 | sort -u").trim()
        }

        def updatedCharts = updatedDirs.split('\n').toList().findAll { fileExists("${it}/Chart.yaml") && fileExists("${it}/templates") }
        if (!updatedCharts.isEmpty()) {
            stage('Publishing charts') {
                sh("git config --global user.email \"${GIT_USER_EMAIL}\" && git config --global user.name \"${GIT_USER_NAME}\"")
                container('k8s-tools') {
                    sh("helm init --client-only")
                }
                updatedCharts.each {
                    if (fileExists("${it}/Chart.yaml")) {
                        println("Packaging chart ${it}")
                            container('k8s-tools') {
                            sh """
                                helm package "${it}" -d docs
                                helm repo index docs --url ${TARGET_URL}
                            """
                        }
                        dir('docs') {
                            sh("git add . && git commit -m \"Publish chart ${it}\"")
                        }
                    }
                }

                sshagent([GIT_PUSH_CREDENTIAL_ID]) {
                    dir('docs') {
                        sh("git push origin HEAD:${GIT_TARGET_BRANCH}")
                    }
                }
            }
        }
    }
}
