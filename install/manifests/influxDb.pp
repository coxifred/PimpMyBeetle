notify {'InfluxDb configuration':}


apt::source { 'influxDb':
  location => 'https://repos.influxdata.com/debian',
  repos    => 'strech stable',
  release  => '9',
}

