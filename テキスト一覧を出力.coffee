String.prototype.startsWith = (str) ->
  return this.slice(0, str.length) == str

String.prototype.endsWith = (suffix) ->
  return this.indexOf(suffix, this.length - suffix.length) != -1

String.prototype.trim = ->
  return this.replace(/^\s+|\s+$/g,'')


class Main
  run: ->
    root = app.activeDocument
    filePath = File.saveDialog("保存先指定(*.csv)")
    if filePath
      data = @export(root)
      file = new File(filePath)
      file.encoding = "UTF-8"
      file.open("w", "TEXT")
      file.write(data.join("\n"))
      file.close()

  export: (root) ->
    dict = []
    used = []
    for textFrame in root.textFrames
      continue if textFrame.locked
      continue if textFrame.visible
      continue if textFrame.contents.replace(/[\n\r]+/g, ' ').replace(/ /, '') == ""
      dict.push(textFrame.contents.replace(/[\n\r]+/g, ' '))

    result = []
    for a in dict.reverse()
      result.push(a)
    result

main = new Main()
main.run()
alert('complete!')
