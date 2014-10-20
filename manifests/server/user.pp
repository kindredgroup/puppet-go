class go::server::user {

  Group <| title == $::go::server::params::group |> ->
  User <| title == $::go::server::params::user |>

}
