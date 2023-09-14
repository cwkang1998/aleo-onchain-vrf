// The 'sg_workshop' program.
program sg_workshop.aleo {

    // only support 4 players, a hack until array is introduced

    // always use key = 1. a hack to bypass the lack of global storage for now
    mapping current_turn: u8 => u128;

    // owner contract
    // aleo166095pymd83g8essrv9wc6hvxp0lwd0gq3ysc5dcy2jxnc9h4s9qma7wj8

    mapping turn_random_number: u128 => field;

    // commitment for users secret
    mapping user_secret_hash: address => field;

    mapping init_game_hash: u8 => field;

    transition init_user_secret_hash(secret: field) {
        let secret_hashed: field = Poseidon2::hash_to_field(secret);
        return then finalize(self.caller, secret_hashed);

    }

    finalize init_user_secret_hash(user: address, secret_hashed: field) {
        // todo: check if user has set this value before
        let existing_secret_hash: field = Mapping::get_or_use(user_secret_hash, user, 0field);
        assert_eq(existing_secret_hash, 0field);

        Mapping::set(user_secret_hash, user, secret_hashed);
    }

    transition init_game_hash(public player_1: address, public player_2: address, 
                public player_3: address, public player_4: address) {
        return then finalize(player_1, player_2, player_3, player_4);
    }

    finalize init_game_hash (public player_1: address, public player_2: address, public player_3: address, public player_4: address) {
        let const_key: u8 = 1u8;
        let existing_game_hash: field = Mapping::get_or_use(init_game_hash, const_key, 0field);
        // make sure game_hash not is set
        assert_eq(existing_game_hash, 0field);

        let user_1_secret_hash: field = Mapping::get_or_use(user_secret_hash, player_1, 0field);
        assert_neq(user_1_secret_hash, 0field);

        let user_2_secret_hash: field = Mapping::get_or_use(user_secret_hash, player_2, 0field);
        assert_neq(user_2_secret_hash, 0field);

        let user_3_secret_hash: field = Mapping::get_or_use(user_secret_hash, player_3, 0field);
        assert_neq(user_3_secret_hash, 0field);

        let user_4_secret_hash: field = Mapping::get_or_use(user_secret_hash, player_4, 0field);
        assert_neq(user_4_secret_hash, 0field);

        let game_hash: field = user_1_secret_hash + user_2_secret_hash + user_3_secret_hash + user_4_secret_hash;
        Mapping::set(init_game_hash, const_key, game_hash);
    }

    transition get_random(secret: field) {
        return then finalize(self.caller, secret);
    }

    finalize get_random(user: address, secret: field){
        // get current run
        // check if user hash matches user

        let user_stored_hash: field = Mapping::get_or_use(user_secret_hash, user, 0field);
        let computed_user_hash: field = Poseidon2::hash_to_field(secret);

        assert_eq(user_stored_hash, computed_user_hash);

        // increment turn number
        let const_key: u8 = 1u8;
        let this_turn: u128 = Mapping::get_or_use(current_turn, const_key, 0u128);
        let next_turn: u128 = this_turn + 1u128;
        Mapping::set(current_turn, const_key, next_turn);    

        // generate random number
        let game_hash: field = Mapping::get_or_use(init_game_hash, const_key, 0field);
        // make sure game_hash is set
        assert_neq(game_hash, 0field);

        let previous_random_number: field = Mapping::get_or_use(turn_random_number, this_turn, 0field);
        let random: field = Poseidon2::hash_to_field(this_turn + previous_random_number + game_hash + secret);

        // set randomness of this_turn
        Mapping::set(turn_random_number, this_turn, random);
    }
}
