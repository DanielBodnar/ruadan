fs = require('fs');

completeMissingFrames = (lastFrame)->
  lastExisting = 1

  for i in [1..lastFrame]
    file = './movie_export/' + i + '.png'
    exists = fs.existsSync(file)
    if exists
      lastExisting = i
    else
      fs.writeFileSync(file, fs.readFileSync('./movie_export/' + lastExisting + '.png'));
    console.log file

completeMissingFrames(9690)

###
ffmpeg -r 1000 -pattern_type glob -i 'movie_export/*.png' -vf "scale=1425:4051" -r 1000 out.mp4
###