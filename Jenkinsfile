/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

/*
 * Copyright 2020 Joyent, Inc.
 */

@Library('jenkins-joylib@v1.0.4') _

pipeline {

    agent {
        label 'platform:true && image_ver:18.4.0 && pkgsrc_arch:x86_64 && ' +
            'dram:8gb && !virt:kvm && fs:pcfs && fs:ufs && jenkins_agent:2'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '30'))
        timestamps()
        parallelsAlwaysFailFast()
    }

    stages {
        stage('trigger smartos-live') {
            when {
                anyOf {
                    branch 'master'
                    triggeredBy cause: 'UserIdCause'
                }
            }
            steps {
                build(job:'joyent-org/smartos-live/prr-OS-8046',
                    wait: false,
                    parameters: [
                        text(name: 'CONFIGURE_PROJECTS',
                            value:
                            'illumos-extra: ${env.BRANCH}: origin\n' +
                            'illumos: master: origin\n' +
                            'local/kvm-cmd: master: origin\n' +
                            'local/kvm: master: origin\n' +
                            'local/mdata-client: master: origin\n' +
                            'local/ur-agent: master: origin')
                    ])
            }
        }
    }
    post {
        always {
            joyMattermostNotification(channel: 'jenkins')
        }
    }
}
