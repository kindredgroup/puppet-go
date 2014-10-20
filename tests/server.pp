class { '::go::server':
  ensure          => present,
  log_directory   => '/var/log/custom-location',
  server_max_mem  => '512m'
}
