// Generated by LiveScript 1.5.0
(function(){
  var bitcoin, bip32utils, bip39, hdkey, waves, monero, network, getWavesAddressByIndex, getMoneroAddressByIndex, getBitcoinAddressByIndex, getEthereumAddressByIndex, getAddressByIndex, generateKeys, generateWallet, out$ = typeof exports != 'undefined' && exports || this;
  bitcoin = require('bitcoinjs-lib');
  bip32utils = require('bip32-utils');
  bip39 = require('bip39');
  hdkey = require('ethereumjs-wallet/hdkey');
  waves = require('waves.js/dist/waves.js');
  monero = require('./monero.js');
  network = bitcoin.networks.bitcoin;
  getWavesAddressByIndex = function(mnemonic, index, network){
    var chainId, utils, address;
    chainId = network.messagePrefix === 'Waves'
      ? 'W'.charCodeAt(0)
      : 'T'.charCodeAt(0);
    utils = new waves['default']({
      chainId: chainId
    });
    address = utils.createAccount(mnemonic + " / " + index).address;
    return address;
  };
  getMoneroAddressByIndex = function(mnemonic, index, network){
    var address;
    address = monero.generateAddress(mnemonic + " / " + index).address;
    return address;
  };
  getBitcoinAddressByIndex = function(mnemonic, index, network){
    var seed, hdnode;
    seed = bip39.mnemonicToSeedHex(mnemonic);
    hdnode = bitcoin.HDNode.fromSeedHex(seed, network).derive(index);
    return hdnode.getAddress();
  };
  getEthereumAddressByIndex = function(mnemonic, index, network){
    var seed, wallet;
    seed = bip39.mnemonicToSeed(mnemonic);
    wallet = hdkey.fromMasterSeed(seed);
    return "0x" + wallet.derivePath("0").deriveChild(index).getWallet().getAddress().toString('hex');
  };
  out$.getAddressByIndex = getAddressByIndex = function(mnemonic, index, network){
    var type, fun;
    type = network != null ? network.messagePrefix : void 8;
    fun = (function(){
      switch (false) {
      case type != null:
        return "Wrong Type";
      case type !== 'Monero':
        return getMoneroAddressByIndex;
      case !(type === 'Waves' || type === 'WavesTest'):
        return getWavesAddressByIndex;
      case type !== 'Ethereum':
        return getEthereumAddressByIndex;
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
