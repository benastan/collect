fs = require 'fs'
_ = require 'underscore'
cwd = process.cwd()

target = undefined
target_queue = []

buckets = {}

collections =
	and: (new_target) ->
		target_queue.push target
		target = [target, new_target].join('/')
	in: (new_target) ->
		target_queue.push target
		target = new_target
	end: -> target = target_queue.pop()
	define: (bucket) ->
		unless buckets[bucket]
			buckets[bucket] = []
			@[bucket] = (files) => @push bucket, files
	push: (bucket, file) ->
		if typeof file is 'string'
			buckets[bucket].push target+'/'+file
		else
			_(file).each (val) =>	@push bucket, val

collections.define 'js'
collections.define 'css'
collections.define 'img'

exists = (file) -> fs.existsSync file
stats = (file) -> fs.statsSync file
is_dir = (dir) -> if exists(dir) then fs.statSync(dir).isDirectory() else undefined

copy_file = (src, tgt) ->
	fs.mkdirSync tgt if !exists tgt
	fs.writeFileSync [tgt, src.split('/').pop()].join('/'), fs.readFileSync(src, 'utf-8'), 'utf-8' if exists src

copy_directory_recursive = (src, target) ->
	dir = fs.readdirSync src
	_(dir).each (file) ->
		file_path = file
		file = [src, file].join('/')
		if is_dir file
			copy_directory_recursive file, [target, file_path].join('/')
		else
			copy_file file, target
						
collect = ->
	_(buckets).each (files, bucket) ->
		tgt_dir = [cwd, bucket].join '/'
		_(files).each (file) -> (if is_dir(file) then copy_directory_recursive else copy_file) [cwd, file].join('/'), tgt_dir

@collect = (component, block) ->
	if arguments.length == 0
		collect()
	else
		target = component
		block.apply collections
	
