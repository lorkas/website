config =
  oauth:
    google:
      clientID: "178909765835.apps.googleusercontent.com"
      clientSecret: "GYXR3j3B3l9j1-DSsBhZSTkD"
    facebook:
      clientID: "131147106979278"
      clientSecret: "1fc41c2f4ad551886f10adce87d2a3a5"
    github:
      clientID: '6da8cbc61b4b9246b899'
      clientSecret: 'e0d3b0d01f47f7248735f71a9e65a35c173eb89a'

  env: 'development'

config.port = if config.env is 'development' then 3100 else 19261

module.exports = config
