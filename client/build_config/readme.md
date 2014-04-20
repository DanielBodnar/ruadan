This is where you can put environment specific config files,
then, if you do ``` require('build_config/some_file') ``` from your script
it will require build_config/some_file_[NODE_ENV]