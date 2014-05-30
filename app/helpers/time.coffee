padNumber = (number) ->
  if (number < 10)
    "0" + number
  else
    number

printTime = (timestamp) ->
  return "N/A" unless timestamp*1
  date = new Date(timestamp*1)
  [
    [
      padNumber(date.getDate()),
      padNumber(date.getMonth()),
      date.getFullYear()
    ].join("/"),
    [
      padNumber(date.getHours()),
      padNumber(date.getMinutes()),
      padNumber(date.getSeconds())
    ].join(":")
  ].join(" ")

module.exports = {
  printTime: printTime
}
