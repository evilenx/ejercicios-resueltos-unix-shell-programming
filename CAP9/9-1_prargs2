# Modify the prargs program to precede each argument by its number. So typing 
 #a 'b c' d
 #
 # should give the following output:
 #
 #     1: a
 #     2: b c
 #     3: d

 # The prargs program is found on page 169

argnum=1

for arg in "$@"
do
    echo "$argnum: $arg"
        ((argnum++))
done

