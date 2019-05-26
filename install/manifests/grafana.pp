notify {'Grafana for PimpMyBeetle installation and configuration':}

package {'curl':
          ensure => present,
        }

class { 'apache': default_vhost => false }

  apache::vhost { 'pimpMyBeetle':
    servername      => 'pimpMyBeetle',
    port            => 80,
    docroot         => '/opt/grafana',
    error_log_file  => 'grafana_error.log',
    access_log_file => 'grafana_access.log',
    directories     => [
      {
        path            => '/opt/grafana',
        options         => [ 'None' ],
        allow           => 'from All',
        allow_override  => [ 'None' ],
        order           => 'Allow,Deny',
      }
    ]
  }->
class {'grafana':
  influxdb_host   => 'localhost',
  influxdb_dbpath => '/db/pimpMyBeetle',
  influxdb_user   => 'pimpMyBeetle',
  influxdb_pass   => 'pimpMyBeetle',
  influxdb_grafana_user   => 'pimpMyBeetle',
  influxdb_grafana_pass   => 'pimpMyBeetle',
}
