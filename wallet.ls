require! {
   \bitcoinjs-lib : bitcoin
   #\bitcoinjs-lib-zcash : zcash
   \bip32-utils : bip32utils
   \bip39
   #\ethereumjs-wallet/hdkey
   #\waves.js/dist/waves.js
   #\./monero.js
   
}

zcash = {}
hdkey = {}
waves = {}
monero = {}





network = bitcoin.networks.bitcoin

buf2hex = (buffer)->
  Array.prototype.map.call(buffer, (x) -> ('00' + x.toString(16)).slice(-2)).join('')

get-waves-fullpair-by-index = (mnemonic, index, network)->
    chain-id = if network.message-prefix is \Waves 
               then 'W'.charCodeAt(0) else 'T'.char-code-at(0)
    utils =  new waves.default { chain-id }
    { address, keys } = utils.create-account "#{mnemonic} / #{index}"
    { private-key, public-key } = keys
    { address, private-key : buf2hex(private-key), public-key : buf2hex(public-key) } 

get-monero-fullpair-by-index = (mnemonic, index, network)->
    { address, spend-key, view-key } = monero.generate-address "#{mnemonic} / #{index}"
    { address, private-key: spend-key, view-key }

get-library = (network)->
    | network.message-prefix.index-of('Zcash Signed Message') > -1 => zcash
    | _ => bitcoin

get-bitcoin-fullpair-by-index = (mnemonic, index, network)->
    seed = bip39.mnemonic-to-seed-hex mnemonic 
    hdnode = get-library(network).HDNode.from-seed-hex(seed, network).derive(index)
    address = hdnode.get-address!
    private-key = hdnode.key-pair.toWIF!
    public-key = hdnode.get-public-key-buffer!.to-string(\hex)
    { address, private-key, public-key }

get-ethereum-fullpair-by-index = (mnemonic, index, network)->
    seed = bip39.mnemonic-to-seed(mnemonic)
    wallet = hdkey.from-master-seed(seed)
    w = wallet.derive-path("0").derive-child(index).get-wallet!
    address = "0x" + w.get-address!.to-string(\hex)
    private-key = w.get-private-key-string!
    public-key = w.get-public-key-string!
    { address, private-key, public-key }
    

export get-fullpair-by-index = (mnemonic, index, network)->
    type = network?message-prefix
    fun =
        | not type? => "Wrong Type"
        | type is \Monero => get-monero-fullpair-by-index
        | type is \Waves or type is \WavesTest => get-waves-fullpair-by-index
        | type is \Ethereum => get-ethereum-fullpair-by-index
        | _ => get-bitcoin-fullpair-by-index 
    fun mnemonic, index, network

export get-address-by-index = (mnemonic, index, network)->
    get-full-pair-by-index(mnemonic, index, network).address

    
export generate-keys = (mnemonic)->
    seed = bip39.mnemonic-to-seed-hex mnemonic 
    hdnode = bitcoin.HDNode.from-seed-hex(seed, network).derive(0)
    private-key = hdnode.key-pair.toWIF!
    address =  hdnode.get-address!
    public-key = hdnode.get-public-key-buffer!.to-string(\hex)
    { private-key, address, public-key }

export generate-wallet = ->
    mnemonic = bip39.generate-mnemonic!
    keys = generate-keys mnemonic
    { mnemonic, keys.address }