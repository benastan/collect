coffee = require 'coffee-script'
fs = require 'fs'

task 'collect-static', ->
	 s = process.cwd()+'/collect-static'
	 coffee.run fs.readFileSync(s, 'utf-8'),
		 filename: 'Cakefile'
