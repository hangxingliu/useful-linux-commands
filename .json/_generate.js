#!/usr/bin/env node

let fs = require('fs-extra');

//Generate argument.js
CLASS = require('../src/arguments').Arguments;
OBJ = new CLASS([]);
RESULT = {};
Object.keys(OBJ).map(v => RESULT[v] = "Function");
fs.writeJSONSync(`${__dirname}/Arguments.json`, RESULT);
console.log("Arguments.js finished!");