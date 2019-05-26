notify {'InfluxDb configuration':}

$db_name='pimpMyBeetle'


apt::source { 'influxDb':
               location => 'https://repos.influxdata.com/debian',
               repos    => 'stable',
               release  => 'stretch',
}

package {'influxdb':
          ensure          => present, 
          install_options => ['--allow-unauthenticated'],
          notify          => Service['influxdb.service'],
}

service {'influxdb.service':
          ensure => 'running',
          enable => true,
        }


exec { "manage_influxdb_${db_name}":
      path      => '/bin:/usr/bin:/opt/influxdb',
      command   => "influx -execute 'CREATE DATABASE ${db_name}'",
      unless    => "influx -execute 'SHOW DATABASES' | grep -qs \"^${db_name}\$\"",
      onlyif    => undef,
      tries     => 3,
      try_sleep => 10,
      require   => Service['influxdb.service'],
    }




