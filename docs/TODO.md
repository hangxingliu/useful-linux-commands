# TODO

## Unit test

- [ ] test query under cli-toolkit, curl, wget and browser

## Core/Common

- [ ] add highlight for text in editor
- [ ] add article/chapter/section block support
	- [ ] awk.sh and awk.manual.sh/awk.article.sh/awk.manual.sh/awk.detailed.sh
- [ ] add querying whole word mode
	- For example: `-whello` would only match hello in `hello world` but not `helloooo~` 

## Frontend

- [ ] remove bootstrap

## Server-side

- [ ] add installers list to URI: `/` for curl/wget
- [ ] add aliases for filename, for example: `gui_software`, `gui` and `desktop`

## Useful commands and installers

- [ ] translate

## Finished

- [x] add .travis-ci
- [x] support `SEO_URL` environment variable for better SEO
	- [x] url in meta tags: `image`, `og:image`, and `twitter:image:src`
	- [x] generate `sitemap.xml` and `robots.txt` into `wwwroot`
- [x] change read file to async in `file.js`
- [x] support query in browser without ajax
	- [x] SEO for each file
	- [x] query in browser without ajax
	- [x] add meta tags
- [x] add visit counter by GA
- [x] support set up server with sepcial port from system environment variable `process.env.PORT`
- [x] support query on the mobile devices without keydown event.
- [x] minify html page and javascript
- [x] set up develop and production version
- [x] add useful commands about iptables/nftables and firewalld
- [x] test all command files have title and description (2018/04/05)
