openid = require 'openid'

relyingParty = new openid.RelyingParty(
  'http:#example.com/verify', # Verification URL (yours)
  null, # Realm (optional, specifies realm for OpenID authentication)
  false, # Use stateless verification
  false, # Strict mode
  []) # List of extensions to enable and include

relyingParty.authenticate identifier, false, (error, authUrl) ->
  if error
    res.writeHead 200
    res.end 'Authentication failed: ' + error.message
  else if not authUrl
    res.writeHead 200
    res.end 'Authentication failed'
  else
    res.writeHead 302, { Location: authUrl }
    res.end()

if parsedUrl.pathname == '/verify'
  # Verify identity assertion
  # NOTE: Passing just the URL is also possible
  relyingParty.verifyAssertion req, (error, result) ->
    res.writeHead 200
    res.end (if not error and result.authenticated then 'Success :)' else 'Failure :(')

else
  # Deliver an OpenID form on all other URLs
  res.writeHead 200
  res.end """
     <!DOCTYPE html><html><body>
     <form method="get" action="/authenticate">
     <p>Login using OpenID</p>
     <input name="openid_identifier" />
     <input type="submit" value="Login" />
     </form></body></html>
   """
