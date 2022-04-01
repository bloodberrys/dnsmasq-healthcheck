# dnsmasq-healthcheck

To enable the dnsmasq container liveness probe and readiness probe, since we know that dnsmasq is using port 53 UDP, we can't do the common healthcheck by using built-in kubernetes healthcheck. Instead we are gonna build our own healthcheck and execute it as liveness and readiness probe. Mounted as a configmap and put on some directory.
