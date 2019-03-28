gitProject = "jobteaser/charts"
final gitRepositoryUrl = "git@github.com:${gitProject}.git"
final gitTimeout = 60

final gitTargetBranchFilter = '*/' + GIT_TARGET_BRANCH

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
            checkout([
                $class: 'GitSCM', branches: [[name: gitTargetBranchFilter]],
                userRemoteConfigs: [[url: gitRepositoryUrl, credentialsId: GIT_CREDENTIAL_ID]],
                extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'docs']],
                gitTool: 'Default'
            ])
        }
        stage('Checking chart updates') {
            container('k8s-tools') {
                sh("helm init --client-only")
            }
            sh("git config --global user.email \"${GIT_USER_EMAIL}\" && git config --global user.name \"${GIT_USER_NAME}\"")
            updated_charts = sh(returnStdout: true, script: "git diff --name-only HEAD^ | cut -d/ -f1 | sort -u | grep -v '^docs\$'").trim()
        }
        if (updated_charts != "") {
            stage('Publishing charts') {
                updated_charts.split('\n').each {
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
                        sh("echo git push origin HEAD:${GIT_TARGET_BRANCH}")
                    }
                }
            }
        }
    }
}
