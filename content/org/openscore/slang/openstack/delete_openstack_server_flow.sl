#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Deletes an OpenStack server.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - username - OpenStack username
#   - password - OpenStack password
#   - server_name - name of server to delete
# Outputs:
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
####################################################

namespace: org.openscore.slang.openstack

imports:
 openstack_content: org.openscore.slang.openstack
 openstack_utils: org.openscore.slang.openstack.utils
flow:
  name: delete_openstack_server_flow
  inputs:
    - host
    - identity_port:
        default: "'5000'"
    - compute_port:
        default: "'8774'"
    - username
    - password
    - server_name
  workflow:
    - authentication:
        do:
          openstack_content.get_authentication_flow:
            - host
            - identity_port
            - username
            - password
        publish:
          - token
          - tenant
          - return_result
          - error_message
    - get_servers:
        do:
          openstack_content.get_openstack_servers:
            - host
            - computePort: compute_port
            - token
            - tenant
        publish:
          - server_list: return_result
          - return_result
          - error_message
    - get_server_id:
        do:
          openstack_utils.get_server_id:
            - server_body: server_list
            - server_name: server_name
        publish:
          - server_ID
          - return_result
          - error_message
    - delete_server:
        do:
          openstack_content.delete_openstack_server:
            - host
            - computePort: compute_port
            - token
            - tenant
            - serverID: server_ID
        publish:
          - return_result
          - error_message
  outputs:
    - return_result
    - error_message