// https://stackoverflow.com/questions/40760716/jenkins-abort-running-build-if-new-one-is-started
// We should only abort older jobs in PR branches, so we have a nice CI history in "stable",
// "testing", and "unstable".
if (env.BRANCH_NAME != "stable" && env.BRANCH_NAME != "testing" && env.BRANCH_NAME != "unstable") {
	def buildNumber = env.BUILD_NUMBER as int
	if (buildNumber > 1) {
		milestone(buildNumber - 1)
	}
	milestone(buildNumber)
}

def runStages(nodeDir) {
	sh "mkdir -p ${nodeDir}"
	dir(nodeDir) {
		try {
			stage("Clone") {
				/* source code checkout */
				checkout scm
				/* we need to update the submodules before caching kicks in */
				sh "git submodule update --init --recursive"
			}

			cache(maxCacheSize: 250, caches: [
				[$class: "ArbitraryFileCache", excludes: "", includes: "**/*", path: "${WORKSPACE}/${nodeDir}/jsonTestsCache"]
			]) {
				stage("Preparations") {
					sh """#!/bin/bash
					set -e
					# macOS shows scary warnings if there are old libraries and object files laying around
					make clean
					# to allow the following parallel stages
					make -j${env.NPROC} QUICK_AND_DIRTY_COMPILER=1 update
					./scripts/setup_scenarios.sh jsonTestsCache
					"""
				}
			}

			stage("Tools") {
				sh """#!/bin/bash
				set -e
				make -j${env.NPROC} LOG_LEVEL=TRACE
				"""
			}

			stage("Test suite") {
				sh "make -j${env.NPROC} DISABLE_TEST_FIXTURES_SCRIPT=1 test"
			}

			stage("REST test suite") {
				sh """#!/bin/bash
				set -e
				./tests/simulation/restapi.sh --data-dir resttest0_data --base-port \$(( 9100 + EXECUTOR_NUMBER * 100 )) \
					--base-rest-port \$(( 7100 + EXECUTOR_NUMBER * 100 )) --base-metrics-port \
				\$(( 8108 + EXECUTOR_NUMBER * 100 )) --resttest-delay 30 --kill-old-processes
				"""
			}

			stage("Testnet finalization") {
				// EXECUTOR_NUMBER will be 0 or 1, since we have 2 executors per Jenkins node
				sh """#!/bin/bash
				set -e
				./scripts/launch_local_testnet.sh --preset minimal --nodes 4 --stop-at-epoch 5 --disable-htop --enable-logtrace \
					--data-dir local_testnet0_data --base-port \$(( 9000 + EXECUTOR_NUMBER * 100 )) --base-rest-port \
					\$(( 7000 + EXECUTOR_NUMBER * 100 )) --base-metrics-port \$(( 8008 + EXECUTOR_NUMBER * 100 )) --timeout 600 \
					--kill-old-processes \
					-- --verify-finalization --discv5:no
				./scripts/launch_local_testnet.sh --nodes 4 --stop-at-epoch 5 --disable-htop --enable-logtrace \
					--data-dir local_testnet1_data --base-port \$(( 9000 + EXECUTOR_NUMBER * 100 )) --base-rest-port \
					\$(( 7000 + EXECUTOR_NUMBER * 100 )) --base-metrics-port \$(( 8008 + EXECUTOR_NUMBER * 100 )) --timeout 2400 \
					--kill-old-processes \
					-- --verify-finalization --discv5:no
				"""
			}
		} catch(e) {
			// we need to rethrow the exception here
			throw e
		} finally {
			// archive testnet logs
			sh """#!/bin/bash
			for D in local_testnet0_data local_testnet1_data resttest0_data; do
				[[ -d "\$D" ]] && tar cjf "\${D}-\${NODE_NAME}.tar.bz2" "\${D}"/*.txt || true
			done
			"""
			try {
				archiveArtifacts("*.tar.bz2")
			} catch(e) {
				println("Couldn't archive artefacts.")
				println(e.toString());
				// we don't need to re-raise it here; it might be a PR build being cancelled by a newer one
			}
			// clean the workspace
			cleanWs(disableDeferredWipeout: true, deleteDirs: true)
		}
	} // dir(...)
}

parallel(
	"Linux": {
		throttle(['nimbus-eth2']) {
			timeout(time: 5, unit: 'HOURS') {
				node("linux") {
					withEnv(["NPROC=${sh(returnStdout: true, script: 'nproc').trim()}"]) {
						runStages("linux")
					}
				}
			}
		}
	},
	"macOS (AMD64)": {
		throttle(['nimbus-eth2']) {
			timeout(time: 5, unit: 'HOURS') {
				node("macos && x86_64") {
					withEnv(["NPROC=${sh(returnStdout: true, script: 'sysctl -n hw.logicalcpu').trim()}"]) {
						runStages("macos_amd64")
					}
				}
			}
		}
	},
	"macOS (ARM64)": {
		throttle(['nimbus-eth2']) {
			timeout(time: 5, unit: 'HOURS') {
				node("macos && arm64") {
					withEnv(["NPROC=${sh(returnStdout: true, script: 'sysctl -n hw.logicalcpu').trim()}"]) {
						runStages("macos_arm64")
					}
				}
			}
		}
	},
)
