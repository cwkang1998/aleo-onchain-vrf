PRIVATEKEY=""
WALLETADDRESS="aleo1c5c24skzvfxuegt0ykeldhcv8s7nstfjk530qdywga5jaacn9g8qk7musl"

APPNAME="sg_workshop"
PATHTOAPP=$(realpath -q $APPNAME)

RECORD="{
  owner: aleo1c5c24skzvfxuegt0ykeldhcv8s7nstfjk530qdywga5jaacn9g8qk7musl.private,
  microcredits: 22197000u64.private,
  _nonce: 2068676621396540585602705960276492482606653280378834371910591207980274568155group.public
}"

snarkos developer deploy "${APPNAME}.aleo" --private-key "${PRIVATEKEY}" --query "https://vm.aleo.org/api" --path "./build" --broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" --fee 1000000 --record "${RECORD}"``