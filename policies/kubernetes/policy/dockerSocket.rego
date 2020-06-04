package main

import data.lib.kubernetes

name = input.metadata.name

default checkDockerSocket = false
 
# checkDockerSocket is true if volumes.hostPath.path is set to /var/run/docker.sock
# and is false if volumes.hostPath is set to some other path or not set.
checkDockerSocket {
  volumes := kubernetes.volumes
  volumes[_].hostPath.path == "/var/run/docker.sock"
}

deny[msg] {
  checkDockerSocket
  # msg = sprintf("%s should not mount /var/run/docker.socker", [name])

  msg := kubernetes.format(
    sprintf(
      "%s %s in %s namespace should not specify /var/run/docker.socker in spec.template.volumes.hostPath.path",
      [lower(kubernetes.kind), kubernetes.name, kubernetes.namespace]
    )
  )
}
