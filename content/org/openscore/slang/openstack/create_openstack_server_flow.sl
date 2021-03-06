#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates and creates an OpenStack server.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - img_ref - image reference for server to be created
#   - username - OpenStack username
#   - password - OpenStack password
#   - server_name - server name
# Outputs:
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
####################################################

namespace: org.openscore.slang.openstack

imports:
 openstack_content: org.openscore.slang.openstack

flow:
  name: create_openstack_server_flow
  inputs:
    - host
    - identity_port:
        default: "'5000'"
    - compute_port:
        default: "'8774'"
    - img_ref
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
    - create_server:
        do:
          openstack_content.create_openstack_server:
            - host
            - computePort: compute_port
            - token
            - tenant
            - imgRef: img_ref
            - serverName: server_name
        publish:
          - return_result
          - error_message
  outputs:
    - return_result
    - error_message


