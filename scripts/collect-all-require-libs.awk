function handler(line, result) {
	match(line, /^([^:]+):/, filename);
	fname = filename[1];
	gsub("../src/", "", fname);
	gsub("../.json/", "", fname);

	match(line, /require\(['"`]([^\.\)]+)['"`]\)/, requires)
	require = requires[1];

	if(require > 0)
		result[require] = result[require] "  " fname "\n";
}

BEGIN {
	DIVIDING_LINE = "=================================="
	
	cmd = "grep ../ -r --include=*.js --exclude-dir=node_modules -e require"

	while ( ( cmd | getline line ) > 0 )
		handler(line, map)
	close(cmd);

	print DIVIDING_LINE

	for(name in map)
		print "\033[1m" name "\033[22m" "\n" map[name]
	
	print DIVIDING_LINE
}
