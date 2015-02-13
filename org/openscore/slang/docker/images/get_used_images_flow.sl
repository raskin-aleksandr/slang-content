#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will return a list of used Docker images.
#
#   Inputs:
#       - docker_host - Docker machine host
#       - docker_username - Docker machine username
#       - docker_password - Docker machine password
#       - private_key_file - the absolute path to the private key file; Default: none
#   Outputs:
#       - used_images_list - list of Docker images currently used on the machine with delimiter "\n"
####################################################
namespace: org.openscore.slang.docker.images

imports:
 docker_images: org.openscore.slang.docker.images
 docker_linux: org.openscore.slang.docker.linux

flow:
  name: get_used_images_flow
  inputs:
    - docker_host
    - docker_username
    - docker_password
    - private_key_file:
        default: "''"

  workflow:
    validate_linux_machine_ssh_access_op:
      do:
        docker_linux.validate_linux_machine_ssh_access:
          - host: docker_host
          - username: docker_username
          - password: docker_password
          - privateKeyFile: private_key_file
      publish:
        - error_message
    get_used_images:
      do:
        docker_images.get_used_images:
          - host: docker_host
          - username: docker_username
          - password: docker_password
          - privateKeyFile: private_key_file
      publish:
        - used_images_list: image_list
        - error_message
  outputs:
    - used_images_list
    - error_message
