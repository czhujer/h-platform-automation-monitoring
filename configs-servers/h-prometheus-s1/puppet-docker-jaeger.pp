docker::run { 'jaeger-agent':
  image   => 'jaegertracing/jaeger-agent:1.18',
  command => "--reporter.grpc.host-port=192.168.121.254:14250",
  ports   => ['6831:6831/udp', '6832:6832/udp'],
}
