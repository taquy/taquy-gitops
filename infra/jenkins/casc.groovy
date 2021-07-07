def jobs = [
  "api.taquy.com": [
    repoName: "taquy-api",
  ]
]

jobs.each {
  name, config -> {
    multibranchPipelineJob(name) {
      displayName(name)
      description("Build docker images and deploy / run docker image on VM")
      branchSources {
        def gitCreds = "taquy-git"
        def repoUri = "git@github.com:taquy/${config.repoName}.git"
        branchSource {
          source {
            git {
              id(name)
              remote(repoUri)
              credentialsId(gitCreds)
              traits {
                gitBranchDiscovery()
                gitTagDiscovery()
                includes('master hotfix/* release/*')
                excludes("")
              }
              buildStrategies {
                buildNoneBranches {}
                buildTags {
                    atLeastDays '-1'
                    atMostDays '1'
                }
              }
            }
          }
        }
        strategy {
          defaultBranchPropertyStrategy {
            props {
              // keep only the last 10 builds
              buildRetentionBranchProperty {
                buildDiscarder {
                  logRotator {
                    daysToKeepStr("-1")
                    numToKeepStr("10")
                    artifactDaysToKeepStr("-1")
                    artifactNumToKeepStr("-1")
                  }
                }
              }
            }
          }
        }
      }
      factory {
        workflowBranchProjectFactory {
          scriptPath('Jenkinsfile')
        }
      }
      configure {
        def traits = it / sources / data / 'jenkins.branch.BranchSource' / source / traits
        traits << 'com.cloudbees.jenkins.plugins.bitbucket.BranchDiscoveryTrait' {
          strategyId(3) // detect all branches
        }
      }
      orphanedItemStrategy {
        discardOldItems {
          numToKeep(0)
        }
        defaultOrphanedItemStrategy {
          pruneDeadBranches(true)
          daysToKeepStr('7')
          numToKeepStr('5')
        }
      }
      properties {
        authorizationMatrix {
          inheritanceStrategy {
            inheriting()
          }
        }
      }
    }
  }
}