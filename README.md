# Onchain VRF

_Making randomness collective, trustless, permissionless_

> 🏆 Grand Prize Winner of the Aleo zkHouse Token2049 Singapore 🏆

## Problem

How can we have randomness for onchain turn-based games that is:

1. fair
2. transparent
3. decentralized

## Solution

An Onchain Verifiable Random Function that consists of pre-game commitments with per-round additive randomness generation.

### How it works

#### Pre-game

- all users generate a _User Secret Hash_ using a User Secret of their choice
- combine everyone's User Secret Hash into a _Game Hash_

#### At every round for each player

1. Generate new Random Number, which is a hash function of:
   1. User Secret
   2. Game Hash
   3. Previous Random Number
   4. Turn Number
2. Circuit ensures User Secret Hash equals to Pre-game User Secret Hash

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
./deploy.sh
```
