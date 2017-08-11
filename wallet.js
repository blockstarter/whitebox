// Generated by LiveScript 1.5.0
(function(){
  var bitcoin, bip32utils, bip39, waves, network, getWavesAddressByIndex, getBitcoinAddressByIndex, getAddressByIndex, generateKeys, generateWallet, out$ = typeof exports != 'undefined' && exports || this;
  bitcoin = require('bitcoinjs-lib');
  bip32utils = require('bip32-utils');
  bip39 = require('bip39');
  waves = require('waves.js/dist/waves.js');
  network = bitcoin.networks.bitcoin;
  getWavesAddressByIndex = function(mnemonic, index, network){
    var symbol, utils, address;
    symbol = network === 'Waves' ? 'W' : 'T';
    utils = new waves['default']({
      chainId: symbol.charCodeAt(0)
    });
    address = utils.createAccount(mnemonic + " / " + index).address;
    return address;
  };
  getBitcoinAddressByIndex = function(mnemonic, index, network){
    var seed, hdnode;
    seed = bip39.mnemonicToSeedHex(mnemonic);
    hdnode = bitcoin.HDNode.fromSeedHex(seed, network).derive(index);
    return hdnode.getAddress();
  };
  out$.getAddressByIndex = getAddressByIndex = function(mnemonic, index, network){
    var type, fun;
    type = network != null ? network.messagePrefix : void 8;
    fun = (function(){
      switch (false) {
      case type != null:
        return "Wrong Network";
      case !(type === 'Waves' || type === 'WavesTest'):
        return getWavesAddressByIndex;
      default:
        return getBitcoinAddressByIndex;
      }
    }());
    return fun(mnemonic, index, network);
  };
  out$.generateKeys = generateKeys = function(mnemonic){
    var seed, hdnode, privateKey, address, publicKey;
    seed = bip39.mnemonicToSeedHex(mnemonic);
    hdnode = bitcoin.HDNode.fromSeedHex(seed, network).derive(0);
    privateKey = hdnode.keyPair.toWIF();
    address = hdnode.getAddress();
    publicKey = hdnode.getPublicKeyBuffer().toString('hex');
    return {
      privateKey: privateKey,
      address: address,
      publicKey: publicKey
    };
  };
  out$.generateWallet = generateWallet = function(){
    var mnemonic, keys;
    mnemonic = bip39.generateMnemonic();
    keys = generateKeys(mnemonic);
    return {
      mnemonic: mnemonic,
      address: keys.address
    };
  };
}).call(this);
