//@ts-check
/// <reference path="../index.d.ts" />

const fs = require('fs');
const path = require('path');
const url = require('url');

let seoURL = '';
let sitemap = '';
module.exports = { init, bindFile, bindAllFiles, generate };

function to2(num) { return num < 10 ? `0${num}` : `${num}`; }
/**
 * @param {string} path
 * @returns {Promise<Date>}
 */
function getFileLastModifyDate(path) {
	return new Promise((resolve, reject) => {
		return fs.stat(path, (e, s) => e ? reject(e) : resolve(s.mtime));
	});
}
/** @param {Date} date */
function getDateString(date) {
	return `${date.getFullYear()}-${to2(date.getMonth() + 1)}-${to2(date.getDate())}`;
}

/** @param {string} _seoURL */
function init(_seoURL) {
	seoURL = _seoURL;
	sitemap = [
		`<?xml version="1.0" encoding="UTF-8"?>`,
		`<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">`,
		`\t<!-- generated date: ${new Date().toString()} -->`,
		``
	].join('\n');
}

/**
 * @param {string} uri
 * @param {string} filePath
 * @param {"always"|"hourly"|"daily"|"weekly"|"monthly"|"yearly"|"never"} [changefreq]
 * @param {number} [priority]
 */
function bindFile(uri, filePath, changefreq = 'weekly', priority = 0.5) {
	return getFileLastModifyDate(filePath)
		.then(date => addPage(uri, getDateString(date), changefreq, priority));
}

/**
 * @param {string[]} fileNames
 * @param {FileMetaInfo[]} metaInfoArray
 */
function bindAllFiles(fileNames, metaInfoArray) {
	return Promise.all(metaInfoArray.map(info => getFileLastModifyDate(info.fullPath)))
		.then(dateArray =>
			fileNames.forEach((fileName, i) =>
				addPage(`/?file=${encodeURIComponent(fileNames[i])}`,
					getDateString(dateArray[i]), 'weekly', 0.7)));
}


/**
 * @param {string} uri
 * @param {string} dateStr
 * @param {"always"|"hourly"|"daily"|"weekly"|"monthly"|"yearly"|"never"} [changefreq]
 * @param {number} priority
 */
function addPage(uri, dateStr, changefreq = 'weekly', priority = 0.5) {
	sitemap += [`\n\t<url>`,
		`\t\t<loc>${encodeURI(url.resolve(seoURL, uri))}</loc>`,
		`\t\t<lastmod>${dateStr.trim().slice(0, 10).replace(/\D/g, '-')}</lastmod>`,
		`\t\t<changefreq>${changefreq}</changefreq>`,
		`\t\t<priority>${priority.toFixed(1)}</priority>`,
		`\t</url>`].join('\n');
}

function generateRobots() {
	return [
		`# robots.txt for useful-linux-commands`,
		`#`,
		`# This is an open-source server that sources storaged on Github:`,
		`#   https://github.com/hangxingliu/useful-linux-commands`,
		`#`,
		``,
		`User-agent: *`,
		``,
		`# disallow useful-installers`,
		`Disallow: /node`,
		`Disallow: /nodejs`,
		`Disallow: /init`,
		`Disallow: /linux`,
		``,
		`Allow: /`,
		``,
		`Sitemap: ${url.resolve(seoURL, '/sitemap.xml')}`
	].join('\n') + '\n';
}


/** @param {string} wwwroot */
function generate(wwwroot) {
	sitemap += `\n</urlset>\n`;

	return Promise.all([
		writeFile('robots.txt', generateRobots()),
		writeFile('sitemap.xml', sitemap)
	]);

	/**
	 * @param {string} fileName
	 * @param {string} content
	 */
	function writeFile(fileName, content) {
		return new Promise((resolve, reject) =>
			fs.writeFile(path.join(wwwroot, fileName), content, error =>
				error ? reject(error) : resolve()));
	}
}
