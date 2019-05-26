notify {'Grafana for PimpMyBeetle installation and configuration':}

apt::source { 'grafana':
               location => 'https://packages.grafana.com/oss/deb',
               repos    => 'main',
               release  => 'stable',
}

package {'grafana':
          ensure          => present,
          install_options => ['--allow-unauthenticated'],
          notify          => Service['grafana-server.service'],
          require         => Apt::Source['grafana'],
}

exec {'setcap':
      path    => "/bin:/sbin:/usr/bin:/usr/sbin",
      command => "setcap cap_net_bind_service+ep /usr/sbin/grafana-server",
      require => Package['grafana'],
     }

ini_setting { 'ini_http':
  ensure  => present,
  path    => '/etc/grafana/grafana.ini',
  section => 'server',
  setting => 'protocol',
  value   => 'http',
  notify  => Service['grafana-server.service'],
  require => Package['grafana'],
}

ini_setting { 'ini_port':
  ensure  => present,
  path    => '/etc/grafana/grafana.ini',
  section => 'server',
  setting => 'http_port',
  value   => '80',
  notify  => Service['grafana-server.service'],
  require => Package['grafana'],
}

ini_setting { 'ini_auth':
  ensure  => present,
  path    => '/etc/grafana/grafana.ini',
  section => 'auth',
  setting => 'disable_login_form',
  value   => 'true',
  notify  => Service['grafana-server.service'],
  require => Package['grafana'],
}

ini_setting { 'ini_anoauth':
  ensure  => present,
  path    => '/etc/grafana/grafana.ini',
  section => 'auth.anonymous',
  setting => 'enabled',
  value   => 'true',
  notify  => Service['grafana-server.service'],
  require => Package['grafana'],
}

ini_setting { 'ini_users_org':
  ensure  => present,
  path    => '/etc/grafana/grafana.ini',
  section => 'users',
  setting => 'auto_assign_org_role',
  value   => 'Admin',
  notify  => Service['grafana-server.service'],
  require => Package['grafana'],
}

ini_setting { 'ini_users_view':
  ensure  => present,
  path    => '/etc/grafana/grafana.ini',
  section => 'users',
  setting => 'viewers_can_edit',
  value   => 'true',
  notify  => Service['grafana-server.service'],
  require => Package['grafana'],
}

ini_setting { 'ini_users_editor':
  ensure  => present,
  path    => '/etc/grafana/grafana.ini',
  section => 'users',
  setting => 'editors_can_admin',
  value   => 'true',
  notify  => Service['grafana-server.service'],
  require => Package['grafana'],
}

grafana_datasource { 'influxdb':
  grafana_url      => 'http://localhost:80',
  grafana_user     => 'admin',
  grafana_password => 'admin',
  grafana_api_path => '/api',
  type             => 'influxdb',
  organization     => 'pimpMyBeetle',
  url              => 'http://localhost:8086',
  user             => 'pimpMyBeetle',
  password         => 'pimpMyBeetle',
  database         => 'pimpMyBeetle',
  access_mode      => 'direct',
  is_default       => true,
}


service {'grafana-server.service':
          ensure  => 'running',
          enable  => true,
          require => [Package['grafana'],Exec['setcap']],
        }




