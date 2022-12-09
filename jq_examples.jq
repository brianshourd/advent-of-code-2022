module { title: "Handy jq functions" };
# These are just some fun things that I've found that I wanted to save
# somewhere, and here is the most likely place that I'll look

# Drop items from an array until a condition is met
def drop_until(cond): until(.[0] | cond; .[1:]);

# Take items from an array until a condition is met
def take_until(cond): .[:-(until(.[0] | cond; .[1:]) | length)];

# Zip two arrays together
def zip_with($arr): [., $arr] | transpose;

# Which gives us a map-with-index function
def map_ix(f): [., [range(length)]] | transpose | map(f);

# There is another way, though, using foreach - this one seems to be faster
def map_ix_fe(f): [foreach .[] as $i([0, null]; [.[0] + 1, ([$i, .[0]] | f)]; .[1])];

# This way is in-between in speed, but very easy and readable
def map_ix_kv(f): to_entries | map(f);
