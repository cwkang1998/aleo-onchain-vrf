program aleo_onchain_vrf.aleo;

struct PlayerInit:
    player_addr as address;
    user_secret_hash as field;

struct Player:
    user as address;
    game_hash as field;
    user_secret_hash as field;

struct RandomNumber:
    user as address;
    game_hash as field;
    random_value as field;
    current_turn as field;


mapping game_hash_to_turn_counter:
	key left as field.public;
	value right as field.public;

function compute_user_secret_hash:
    input r0 as field.private;
    hash.psd2 r0 into r1 as field;
    assert.neq r1 0field;
    output r1 as field.private;


function init_game_hash:
    input r0 as PlayerInit.public;
    input r1 as PlayerInit.public;
    input r2 as PlayerInit.public;
    input r3 as PlayerInit.public;
    assert.neq r0.user_secret_hash 0field;
    assert.neq r1.user_secret_hash 0field;
    assert.neq r2.user_secret_hash 0field;
    assert.neq r3.user_secret_hash 0field;
    add r0.user_secret_hash r1.user_secret_hash into r4;
    add r4 r2.user_secret_hash into r5;
    add r5 r3.user_secret_hash into r6;
    cast r0.player_addr r6 r0.user_secret_hash into r7 as Player;
    cast r1.player_addr r6 r1.user_secret_hash into r8 as Player;
    cast r2.player_addr r6 r2.user_secret_hash into r9 as Player;
    cast r3.player_addr r6 r3.user_secret_hash into r10 as Player;
    cast r7.user r6 1field 0field into r11 as RandomNumber;
    output r7 as Player.private;
    output r8 as Player.private;
    output r9 as Player.private;
    output r10 as Player.private;
    output r11 as RandomNumber.private;

    finalize r6;

finalize init_game_hash:
    input r0 as field.public;
    set 0field into game_hash_to_turn_counter[r0];


function get_random:
    input r0 as RandomNumber.private;
    input r1 as Player.private;
    input r2 as field.private;
    assert.neq r0.user self.caller;
    assert.neq r0.user r1.user;
    assert.eq r0.game_hash r1.game_hash;
    assert.neq r0.game_hash 0field;
    hash.psd2 r2 into r3 as field;
    assert.eq r1.user_secret_hash r3;
    add r0.current_turn 1field into r4;
    add r4 r0.random_value into r5;
    add r5 r0.game_hash into r6;
    add r6 r2 into r7;
    hash.psd2 r7 into r8 as field;
    cast r1.user r0.game_hash r8 r4 into r9 as RandomNumber;
    output r9 as RandomNumber.private;

    finalize r0.game_hash r4;

finalize get_random:
    input r0 as field.public;
    input r1 as field.public;
    get game_hash_to_turn_counter[r0] into r2;
    add r2 1field into r3;
    assert.eq r1 r3;
    set r1 into game_hash_to_turn_counter[r0];
