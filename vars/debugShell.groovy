#!/usr/bin/env groovy
import groovy.lang.Closure
import hudson.FilePath

def call(Map givenConfig = [:]) {
    def defaultConfig = [
        haltExecution: true
    ]
    def config = defaultConfig << givenConfig
    echo "Spawning debug shell socket with config:"
    config.each{ k, v -> echo "${k}: ${v}" }

    dir('/tmp/debugshell') {
        writeFile file: 'bashrc.sh', text: libraryResource('debugshell/bashrc.sh')
        writeFile file: 'create.sh', text: libraryResource('debugshell/create.sh')
        sh 'chmod +x create.sh'
    }

    dir("${env.WORKSPACE}") {
        withEnv(["HALT_EXECUTION=${String.valueOf(config['haltExecution'])}"]) {
            sh '/tmp/debugshell/create.sh'
        }
    }
}