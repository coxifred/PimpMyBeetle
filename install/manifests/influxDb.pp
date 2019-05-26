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
          require         => Apt::Source['influxDb'],
}

service {'influxdb.service':
          ensure  => 'running',
          enable  => true,
          require => Package['influxdb'],
        }


exec { "manage_influxdb_${db_name}":
      path      => '/bin:/usr/bin',
      command   => "influx -execute 'CREATE DATABASE ${db_name}'",
      unless    => "influx -execute 'SHOW DATABASES' | grep -qs \"^${db_name}\$\"",
      onlyif    => undef,
      tries     => 3,
      try_sleep => 10,
      require   => Service['influxdb.service'],
    }




