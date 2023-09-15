# Onchain VRF

_Making randomness collective, trustless, permissionless_

> 🏆 Grand Prize Winner of the Aleo zkHouse Token2049 Singapore 🏆

## Problem Statement

How can we have randomness for onchain turn-based games that is:

1. fair
2. transparent
3. decentralized

## Solution

Pre-game commitments with per-round additive randomness generation.

### How it works

#### Pre-game

- all users generate a User Secret Hash
- combine everyone's User Secret Hash into a Game Hash

#### At Every Round For Each Player

1. Randomness is a hash function of:
   1. User Secret
   2. Game Hash
2. Circuit: User Secret hash == Pre-game User Secret Hash

### How to run

```bash
./demo.sh
```

### How to build

```bash
leo build
```

### How to deploy

The contract is deployed at `testnet3` at `at1gvyv90m3rqyzmq4qtyt9a0m6s2m8qdlcee9prefhvvuf70pn8upq4k0wqn`

You can deploy your own running:

```bash
deploy.sh
```
