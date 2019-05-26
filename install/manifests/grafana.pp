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

service {'grafana-server.service':
          ensure  => 'running',
          enable  => true,
          require => Package['grafana-server.service'],
        }
