PRIVATEKEY=""
WALLETADDRESS="aleo1c5c24skzvfxuegt0ykeldhcv8s7nstfjk530qdywga5jaacn9g8qk7musl"

APPNAME="aleo_onchain_vrf"
PATHTOAPP=$(realpath -q $APPNAME)

RECORD="{
  owner: aleo1c5c24skzvfxuegt0ykeldhcv8s7nstfjk530qdywga5jaacn9g8qk7musl.private,
  microcredits: 17653000u64.private,
  _nonce: 2229326433831345831518623901950621959388651154812884403863750294006815233042group.public
}"

snarkos developer deploy "${APPNAME}.aleo" --private-key "${PRIVATEKEY}" --query "https://vm.aleo.org/api" --path "./build" --broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" --fee 1000000 --record "${RECORD}"``