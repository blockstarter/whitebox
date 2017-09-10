require! {
   \./container.js
   \./wallet.js
}

{ get-container, get-container-list, sign } = container
{ generate-wallet, generate-keys, get-address-by-index, get-fullpair-by-index } = wallet

exports <<< {
   get-container
   generate-wallet
   get-container-list
   get-fullpair-by-index
   generate-keys 
   get-address-by-index
   sign
}


    


