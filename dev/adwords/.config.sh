PATH=../../scripts/adwords:$PATH

filter() {
	grep -vP 'web.+web' | grep -vP 'url.+web' | grep -vP 'web.+url' | grep -vP 'free.+free' | grep -vP 'ware.+ware' | grep -vP 'auto.+auto'
}

csv() {
	#check_lcnt.pl 20000 80 | txt2csv.pl > out/`basename $0 .sh`.csv
	txt
}

txt() {
	check_lines.pl 20000 80 > out/`basename $0 .sh`.txt
}
