#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Gets the IP of the specified Docker container.
#
# Inputs:
#   - containerName - container name
#   - host - Docker machine host
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file - Default: none
#   - arguments - optional - arguments to pass to the command; Default: none
#   - characterSet - optional - character encoding used for input stream encoding from target machine Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false - Default: false
#   - timeout - optional - time in milliseconds to wait for command to complete - Default: 90000
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false - Default: false
# Outputs:
#   - container_ip - IP of the specified container
#   - error_message - error message
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: org.openscore.slang.docker.containers

operation:
  name: get_container_ip
  inputs:
    - containerName
    - cmdParams:
        default: "''"
        overridable: false
    - host
    - port:
        default: "'22'"
    - username
    - password
    - privateKeyFile:
        default: "''"
    - command:
        default: >
            "docker inspect --format '{{ .NetworkSettings.IPAddress }}' " + containerName
        overridable: false
    - arguments:
        default: "''"
    - characterSet:
        default: "'UTF-8'"
    - pty:
        default: "'false'"
    - timeout:
        default: "'90000'"
    - closeSession:
        default: "'false'"
  action:
    java_action:
      className: org.openscore.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - container_ip: returnResult[:-1]
    - error_message: "'' if 'STDERR' not in locals() else STDERR if returnCode == '0' else returnResult"
  results:
    - SUCCESS : returnCode == '0' and (not 'Error' in STDERR)
    - FAILURE