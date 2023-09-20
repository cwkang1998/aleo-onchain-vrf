// The 'aleo_onchain_vrf' program.
program aleo_onchain_vrf.aleo {

    // owner contract
    // aleo166095pymd83g8essrv9wc6hvxp0lwd0gq3ysc5dcy2jxnc9h4s9qma7wj8

    // TODO: use array when supported. currently it can only support a fixed number of players (4 in this implementation)

    // Stores player's stage during initial stage
    // - `player_addr`      :  player's address
    // - `user_secret_hash` :  player's secret hash
    struct PlayerInit {
        player_addr: address;
        user_secret_hash: field;
    }

    // Stores player's state after initial stage
    // - `user`             :  player's address
    // - `game_hash`        :  game hash computed during initial stage
    // - `user_secret_hash` :  player's secret hash
    struct Player {
        user: address;
        game_hash: field;
        user_secret_hash: field;
    }

    // Store random number state
    // - `user`            :  address of player who's computing the new random value (player who generated the random number)
    // - `game_hash`       :  game hash computed during initial stage
    // - `random_value`    :  random value generated from previous random value, game hash, and user's secret
    // - `current_turn`    :  current turn number (similar to nonce)
    struct RandomNumber{
        user: address;
        game_hash: field;
        random_value: field;
        current_turn: field;
    }

    // Maps game hash -> counter
    mapping game_hash_to_turn_counter: field => field;

    // Helper function to calculate secret hash from secret
    transition compute_user_secret_hash(secret: field) -> field {
        let secret_hashed: field = Poseidon2::hash_to_field(secret);
        assert_neq(secret_hashed, 0field);
        return secret_hashed;
    }

// Create initial game hash and RandomNumber using all players' secret hashes
    transition init_game_hash(
        public player_init_1: PlayerInit,
        public player_init_2: PlayerInit, 
        public player_init_3: PlayerInit, 
        public player_init_4: PlayerInit
    ) -> (Player, Player, Player, Player, RandomNumber) {
        
        // ensure user secret hash is not 0
        assert_neq(player_init_1.user_secret_hash, 0field);
        assert_neq(player_init_2.user_secret_hash, 0field);
        assert_neq(player_init_3.user_secret_hash, 0field);
        assert_neq(player_init_4.user_secret_hash, 0field);
        
        // initial game hash is the summation of all users' secret hashes
        let game_hash: field = player_init_1.user_secret_hash + player_init_2.user_secret_hash + player_init_3.user_secret_hash + player_init_4.user_secret_hash;

        // create Player structs for each player
        let player_1: Player = Player {
            game_hash,
            user: player_init_1.player_addr,
            user_secret_hash: player_init_1.user_secret_hash
        };
        let player_2: Player = Player {
            game_hash,
            user: player_init_2.player_addr,
            user_secret_hash: player_init_2.user_secret_hash
        };
        let player_3: Player = Player {
            game_hash,
            user: player_init_3.player_addr,
            user_secret_hash: player_init_3.user_secret_hash
        };
        let player_4: Player = Player {
            game_hash,
            user: player_init_4.player_addr,
            user_secret_hash: player_init_4.user_secret_hash
        };

        // create RandomNumber struct
        let starting_record: RandomNumber = RandomNumber {
            user: player_1.user,  // set initial to belong to Player 1
            game_hash, 
            random_value: 1field, // set initial random value to 1
            current_turn: 0field  // set initial turn to 0, current_turn is similar to a nonce
        };
        
        return (player_1, player_2, player_3, player_4, starting_record) then finalize(game_hash);
    }

    finalize init_game_hash (game_hash: field) {
        // add initial game hash for turn 0 to mapping
        Mapping::set(game_hash_to_turn_counter, game_hash, 0field);
    }

    // Compute the new random value using the previous random value, game hash, and current player's secret
    transition get_random(last_random: RandomNumber, player: Player, secret: field) -> RandomNumber {
        assert_neq(last_random.user, self.caller);  // ensure caller is not the last player who just generated the game hash
        assert_neq(last_random.user, player.user);  // ensure player computing is not the last player who just generated the game hash
        assert_eq(last_random.game_hash, player.game_hash);  // ensure player's game hash is the same as the initial game hash
        assert_neq(last_random.game_hash, 0field);  // ensure previous game hash is not 0
        
        let computed_user_hash: field = Poseidon2::hash_to_field(secret);
        assert_eq(player.user_secret_hash, computed_user_hash);  // ensure player's secret hash is valid

        // increment current turn by 1 (similar to nonce)
        let current_turn: field = last_random.current_turn + 1field;
        // compute new random value
        let new_random: field = Poseidon2::hash_to_field(current_turn + last_random.random_value + last_random.game_hash + secret);

        return RandomNumber {
            user: player.user,
            game_hash: last_random.game_hash,
            random_value: new_random,
            current_turn: current_turn
        } then finalize(last_random.game_hash, current_turn);
    }

    finalize get_random(game_hash: field, current_turn: field){
        let last_turn: field = Mapping::get(game_hash_to_turn_counter, game_hash);  // get last turn from mapping
        assert_eq(current_turn, last_turn + 1field); // ensure turn is incremented by 1
        Mapping::set(game_hash_to_turn_counter, game_hash, current_turn);  // create new mapping with game hash and turn
    }
}
