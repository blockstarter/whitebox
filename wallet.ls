require! {
   \bitcoinjs-lib : bitcoin
   \bip32-utils : bip32utils
   \bip39
   \waves.js/dist/waves.js
}

network = bitcoin.networks.bitcoin

get-waves-address-by-index = (mnemonic, index, network)->
    chain-id = if network.message-prefix is \Waves 
               then 'W'.charCodeAt(0) else 'T'.charCodeAt(0)
    utils =  new waves.default { chain-id  }
    { address } = utils.create-account "#{mnemonic} / #{index}"
    address
    
get-bitcoin-address-by-index = (mnemonic, index, network)->
    seed = bip39.mnemonic-to-seed-hex mnemonic 
    hdnode = bitcoin.HDNode.from-seed-hex(seed, network).derive(index)
    hdnode.get-address!

export get-address-by-index = (mnemonic, index, network)->
    type = network?message-prefix
    fun =
        | not type? => > "Wrong Type"
        | type is \Waves or type is \WavesTest => get-waves-address-by-index
        | _ => get-bitcoin-address-by-index 
    fun mnemonic, index, network
    
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