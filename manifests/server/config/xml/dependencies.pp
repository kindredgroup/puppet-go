class go::server::config::xml::dependencies (
  $install_augeas  = $::go::server::install_augeas,
  $augeas_packages = $::go::server::augeas_packages,
) {

    if $install_augeas {
      ensure_packages($augeas_packages)
      Package[$augeas_packages] -> Augeas <| tag == 'go::server::config::xml' |>
    }

}
