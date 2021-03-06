#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#####################################################
# Retrieves the public IPs of machines deployed in a CoreOS cluster.
#
# Inputs:
#   - coreos_host - CoreOS machine host; can be any machine from the cluster
#   - coreos_username - CoreOS machine username
#   - private_key_file - the absolute path to the private key file - Default: none
# Outputs:
#   - machines_public_ip_list: space delimeted list of public IP addresses of machines in cluster
#   - error_Message - possible error message
#####################################################

namespace: org.openscore.slang.coreos

imports:
 coreos: org.openscore.slang.coreos

flow:
  name: list_machines_public_ip

  inputs:
    - coreos_host
    - coreos_username
    - coreos_password:
        default: "''"
        overridable: false
    - private_key_file:
        default: "''"
    - machines_public_ip_list:
        default: "''"
        overridable: false

  workflow:
    - list_machines_id:
        do:
          coreos.list_machines_id:
            - host: coreos_host
            - username: coreos_username
            - password: coreos_password
            - privateKeyFile: private_key_file
        publish:
            - machines_id_list
            - error_message

    - get_machine_public_ip:
            loop:
                for: machine_id in machines_id_list.split(' ')
                do:
                  coreos.get_machine_public_ip:
                    - machine_id
                    - host: coreos_host
                    - username: coreos_username
                    - password: coreos_password
                    - privateKeyFile: private_key_file
                publish:
                    - machines_public_ip_list: fromInputs['machines_public_ip_list'] + public_ip + ' '
                    - error_message

  outputs:
    - machines_public_ip_list: machines_public_ip_list[:-1]
    - error_message