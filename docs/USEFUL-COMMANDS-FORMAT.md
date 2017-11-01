# USEFUL COMMANDS FORMAT

## Basic commands structure:

1. First level: **Files** are named like `name.sh`/`name.manual.sh`/`name.article.sh`/...
2. Second level:  **Chapters** 
3. *(Optional)* Third level: **Sections**


## Valid section prefix:

1. ignore case and first space
2. `:` could be replaced to `.`

- `section:`
- `warning:`
- `example:`
- `step:`
- `step1:`/`step2:`/...
- `step 1:`/`step 2:`/...
- `1:`/`2:`/`3:`/...

## Format structure in file demo 

demo format:

	# File name
	# Chapter title
	# Step1: Section title
	...
	# Step 2: Section title
	...
	# Section: Section title
	# Warning: Section title
	# Example: Section title
	...
	# normal comments
	``` awk
	#codes...
	...
	```

	#===

	# Chapter title
	...


1. section title could be ignored
2. section prefix is ignore case

demo:

	# AWK
	# AWK 基础知识
	# Section: 基本命令
	awk -v var=value 'awk commands' inputFile 
	# Example:
	``` awk
	{print $0;}END{print "END";}
	```


	# AWK 扩展
	...
	# =========
	# AWK 资源
	...
