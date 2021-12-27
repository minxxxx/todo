n=0
max=9
set -- # this sets $@ [the argv array] to an empty list.

while [ "$n" -le "$max" ]; do
	set -- "$@" "ex0$n" # this adds s$n to the end of $@
	n=$(( $n + 1 ));
done 

mkdir "$@"
