Collect
=======

A paradigm-agnostic static files collector especially for trigger.io projects leveraging npm.

# Use npm

Collect makes it easy to manage libraries and dependencies in a trigger.io project. Use npm to load libraries, and use collect to put them in the right place.

# Example: Load backbone, underscore and jquery

## Setup

In your project's `package.json`:

	{
		"name": "your-dumb-project"
		, "version": "99.9.9-stfu"
		, "dependencies": {
			"jquery-component": "*"
			, "backbone": "*"
			, "underscore": "*"
			, "collect": "https://github.com/benastan/collect/tarball/master"
		}
	}

Run:

	npm install

If you want the `collect-static` cake task available from your project root, add this line to your Cakefile:

	coffee.run fs.readFileSync('node_modules/collect/Cakefile').toString()

## Collect some static

Create a file called `collect-static.coffee` with the following files:

	collect = require('collect').collect

	// Collect node modules
	collect 'node_modules', ->
		
		// drop into jquery-component/dist
		@and 'jquery-component/dist'
		@js 'jquery.js'

		// jump back to node_modules
		@end()
	
		@and 'backbone'
		@js 'backbone.js'
		@end()
	
		@and 'bootstrap'
		@img 'img'
		@end()
	
		@and 'underscore'
		@js 'underscore.js'
	
	collect()
