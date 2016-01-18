Filter = module.exports = ->
  (words_count, round=true) ->
    lessThanAMinute = "less than a minute"
    minShortForm = "min"

    # The average human reading speed (WPM)
    wordsPerMinute = 250

    # define words per second based on words per minute
    wordsPerSecond = wordsPerMinute / 60

    # define total reading time in seconds
    totalReadingTimeSeconds = words_count / wordsPerSecond

    # define reading time in minutes
    if round == true
      readingTimeMinutes = Math.round totalReadingTimeSeconds / 60
    else readingTimeMinutes = Math.floor totalReadingTimeSeconds / 60

    # define remaining reading time seconds
    readingTimeSeconds = Math.round totalReadingTimeSeconds - (readingTimeMinutes * 60)

    # If we are rounding off the seconds then
    if round
      # if minutes are greater than 0 then set reading time by the minute
      if readingTimeMinutes > 0
        return "#{readingTimeMinutes} #{minShortForm}"

      # set reading time as less than a minute
      else return lessThanAMinute

    else
      # format reading time
      readingTime = "#{readingTimeMinutes}:#{readingTimeSeconds}"

      # set reading time in minutes and seconds
      return readingTime