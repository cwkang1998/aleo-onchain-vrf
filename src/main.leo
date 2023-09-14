// The 'aleo_onchain_vrf' program.
program aleo_onchain_vrf.aleo {

    // only support 4 players, a hack until array is introduced

    // Maps game -> counter
    mapping game_hash_turn_counter: field => field;

    // owner contract
    // aleo166095pymd83g8essrv9wc6hvxp0lwd0gq3ysc5dcy2jxnc9h4s9qma7wj8

    struct MemberInit {
        member_addr: address;
        user_secret_hash: field;
    }

    struct Member {
        user: address;
        game_hash: field;
        user_secret_hash: field;
    }

    struct RandomNumber{
        user: address;
        game_hash: field;
        random_value: field;
        current_turn: field;
    }

    transition compute_user_secret_hash(secret: field) -> field {
        let secret_hashed: field = Poseidon2::hash_to_field(secret);
        assert_neq(secret_hashed, 0field);
        return secret_hashed;
    }

    transition init_game_hash(
        public player_1: MemberInit,
        public player_2: MemberInit, 
        public player_3: MemberInit, 
        public player_4: MemberInit
    ) -> (Member, Member, Member, Member, RandomNumber) {
        assert_neq(player_1.user_secret_hash, 0field);
        assert_neq(player_2.user_secret_hash, 0field);
        assert_neq(player_3.user_secret_hash, 0field);
        assert_neq(player_4.user_secret_hash, 0field);
        let game_hash: field = player_1.user_secret_hash + player_2.user_secret_hash + player_3.user_secret_hash + player_4.user_secret_hash;

        let member_1: Member = Member {
            game_hash,
            user: player_1.member_addr,
            user_secret_hash: player_1.user_secret_hash
        };
        let member_2: Member = Member {
            game_hash,
            user: player_2.member_addr,
            user_secret_hash: player_2.user_secret_hash
        };
        let member_3: Member = Member {
            game_hash,
            user: player_3.member_addr,
            user_secret_hash: player_3.user_secret_hash
        };
        let member_4: Member = Member {
            game_hash,
            user: player_4.member_addr,
            user_secret_hash: player_4.user_secret_hash
        };

        let starting_record: RandomNumber = RandomNumber {
            user: member_1.user,
            game_hash, 
            random_value: 1field,
            current_turn: 0field
        };
        
        return (member_1, member_2, member_3, member_4, starting_record) then finalize(game_hash);
    }

    finalize init_game_hash (game_hash: field) {
        Mapping::set(game_hash_turn_counter, game_hash, 0field);
    }

    transition get_random(last_random: RandomNumber, member: Member, secret: field) -> (field, field) {
        assert_neq(last_random.user, self.caller);
        assert_neq(last_random.user, member.user);
        assert_eq(last_random.game_hash, member.game_hash);
        assert_neq(last_random.game_hash, 0field);
        
        let computed_user_hash: field = Poseidon2::hash_to_field(secret);
        assert_eq(member.user_secret_hash, computed_user_hash);
        return (member.user_secret_hash, computed_user_hash);

        // let current_turn: field = last_random.current_turn + 1field;
        // let new_random: field = Poseidon2::hash_to_field(current_turn + last_random.random_value + last_random.game_hash + secret);

        // return RandomNumber {
        //     user: member.user,
        //     game_hash: last_random.game_hash,
        //     random_value: new_random,
        //     current_turn: current_turn
        // } then finalize(last_random.game_hash, current_turn);
    }

    // finalize get_random(game_hash: field, current_turn: field){
    //     let last_turn: field = Mapping::get(game_hash_turn_counter, game_hash);
    //     assert_eq(current_turn, last_turn + 1field);
    //     Mapping::set(game_hash_turn_counter, game_hash, current_turn);    
    // }
}
