environment = switch process.env.NODE_ENV
  when 'dev', 'development' then 'development'
  when 'stage', 'staging' then 'staging'
  when 'test', 'testing' then 'testing'
  else 'production'

console.log 'NODE_ENV="'.green+process.env.NODE_ENV?.blue+'"'.green
console.log 'running as "'.green+environment?.blue+'"'.green

config =
  # A few random strings from http://www.random.org/strings/?num=100&len=16&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new
  sessionSecret: "slthlGgyAfGyGGM4LT9rWyWTOyMYCWdoons0toYtIhylb3n61dQ8EXdKRXQ3EWyX"
  
  # These are all testing accounts. Will switch to real ones and not have them on gitnub when accounts are done.
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

  env: environment

config.port = if config.env is 'development' then 3100 else 19261

module.exports = config
