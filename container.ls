require! {
   \bitcoinjs-lib : bitcoin
   \bip32-utils : bip32utils
   \bip39
   \fs
   \prelude-ls : p
   \bitcore-message : \Message
   \bitcore-lib : bitcore
   \superagent
   \./wallet.js
}

{ generate-keys } = wallet

network = bitcoin.networks.bitcoin




guid = ->
  s4 = ->
    Math.floor((1 + Math.random!) * 0x10000).toString(16).substring 1
  s4! + s4! + \- + s4! + \- + s4! + \- + s4! + \- + s4! + s4! + s4!


request = (config, path, body, cb)->
    parts = path.match(/^(A-Z+) (.+)$/)
    type = parts.1.to-lower-case!
    { mnemonic, name, node } = config
    url-part = parts.2.replace(/:name/, name)
    ck = generate-keys message
    url = "#{node}#{url-part}"
    requestid = guid!
    message =
       [name, body, requestid] |> p.map JSON.stringify |> p.join \;
    private-key2 = bitcore.PrivateKey.fromWIF(ck.private-key)
    signature = Message(message).sign(private-key2)
    req = superagent[type] url
    req
      .send body
      .set \requestid, requestid
      .set \address, ck.address
      .set \signature, signature
      .end cb

simple = (path, config, cb)-->
  err, data <-! request config, path, {}
  cb err, data.text

status = simple "GET /container/status/:name"

start = simple "POST /container/start/:name"

stop = simple "POST /container/stop/:name"

create = (config, data, cb)-->
  return cb "Data Must be Object" if typeof! data isnt \Object
  return cb "'code' is required field" if typeof! data.code isnt \String
  err, data <-! request config, "POST /container/create/:name", data
  cb err, data.text

operation = (config, operation, data, cb)-->
  return cb "Data Must be Object" if typeof! data isnt \Object
  err, data <-! request config, "POST /container/:name/#{operation}", data
  cb err, data.text

export get-container = (config)->
  status: status config
  create: create config
  start: start config
  stop: stop config
  operation: operation config

