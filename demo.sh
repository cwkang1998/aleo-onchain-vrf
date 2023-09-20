# echo ""--- Calculating secret hash from given secret... "---"
# leo run compute_user_secret_hash
# sleep 2

echo "--- Preparing players... ---"
leo run init_game_hash
sleep 3

echo "\n\n--- First round - Player 2 compute new random value with Player 1's random value ---"
leo run get_random \
  "{ \
  user: aleo1cd3v453y0n0ntl2gw7l3fpksp2ae9s46rzlt87mup2gth0asygzq9k5q0l, \
  game_hash: 7571057015730941990143459213534650058818343735290421916417010434384442343523field, \
  random_value: 1field, \
  current_turn: 0field \
  }" \
  "{ \
  user: aleo1k4pdvq6gh8duzqd3g4p852p2j7xn76dhfmx0ds9lj6sg96g7k5xqsxvc5y, \
  game_hash: 7571057015730941990143459213534650058818343735290421916417010434384442343523field, \
  user_secret_hash: 1916866650744865271241509820990367882428103130043613420607863419653524065772field \
  }" \
  101field
sleep 2

echo "\n\n--- Second round - Player 3 compute new random value with Player 2's random value ---"
leo run get_random \
  "{ \
  user: aleo1k4pdvq6gh8duzqd3g4p852p2j7xn76dhfmx0ds9lj6sg96g7k5xqsxvc5y, \
  game_hash: 7571057015730941990143459213534650058818343735290421916417010434384442343523field, \
  random_value: 8059017103688514211272798575563686953022290253025759700967778270233158649266field, \
  current_turn: 1field \
  }" \
  "{ \
  user: aleo19hdxv0h4nhrtd68cgvfszvavhgxx765zj2vm93k2dnc55vdza5zq5nwxsh, \
  game_hash: 7571057015730941990143459213534650058818343735290421916417010434384442343523field, \
  user_secret_hash: 8063113796567896899791860693652578285507024304475589383680929656597160250795field \
  }" \
  102field
sleep 2

echo "\n\n--- Final round - Player 4 compute new random value with Player 3's random value ---"
leo run get_random \
  "{ \
  user: aleo19hdxv0h4nhrtd68cgvfszvavhgxx765zj2vm93k2dnc55vdza5zq5nwxsh, \
  game_hash: 7571057015730941990143459213534650058818343735290421916417010434384442343523field, \
  random_value: 5663251201679387716308634082472199027207490489903956486817712399394989227962field, \
  current_turn: 2field \
  }" \
  "{ \
  user: aleo1c5c24skzvfxuegt0ykeldhcv8s7nstfjk530qdywga5jaacn9g8qk7musl, \
  game_hash: 7571057015730941990143459213534650058818343735290421916417010434384442343523field, \
  user_secret_hash: 7144296222674377988574676364971060105981249694178697067231339719749617873236field \
  }" \
  103field
sleep 2

echo "DONE!"
