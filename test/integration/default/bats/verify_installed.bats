
@test 'Dataloop-agent is up and running' {
  pgrep dataloop-agent
}

@test 'agent.conf contains an api key' {
  grep ^API_KEY /etc/dataloop/agent.conf
}

