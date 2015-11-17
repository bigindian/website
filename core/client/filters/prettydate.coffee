Filter = module.exports = ->
  _createHandler = (divisor, noun, restOfString="") ->
    (diff) ->
      n = Math.floor diff / divisor
      pluralizedNoun = "#{noun}#{if n > 1 then "s" else ""}"
      "#{n} #{pluralizedNoun} #{restOfString}"

  (date_raw) ->
    formatters = [
      {
        threshold: -172800
        handler: _createHandler -86400, "day"
      }
      {
        threshold: -86400
        handler: -> "tommorow"
      }
      {
        threshold: -3600
        handler: _createHandler -3600, "hour"
      }
      {
        threshold: -60
        handler: _createHandler -60, "minute"
      }
      {
        threshold: 0
        handler: _createHandler -1, "second"
      }
      {
        threshold: 1
        handler: -> "just now"
      }
      {
        threshold: 60
        handler: _createHandler 1, "second", "ago"
      }
      {
        threshold: 3600
        handler: _createHandler 60, "minute", "ago"
      }
      {
        threshold: 86400
        handler: _createHandler 3600, "hour", "ago"
      }
      {
        threshold: 172800
        handler: -> "yesterday"
      }
      {
        threshold: 604800
        handler: _createHandler 86400, "day", "ago"
      }
      {
        threshold: 2592000
        handler: _createHandler 604800, "week", "ago"
      }
      {
        threshold: 31536000
        handler: _createHandler 2592000, "month", "ago"
      }
      {
        threshold: Infinity
        handler: _createHandler 31536000, "year", "ago"
      }
    ]

    date = new Date date_raw
    now = new Date
    diff = (now.getTime() - date.getTime()) / 1000
    for f in formatters then return f.handler diff if diff < f.threshold
    ""