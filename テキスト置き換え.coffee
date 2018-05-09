String.prototype.startsWith = (str) ->
  return this.slice(0, str.length) == str

String.prototype.endsWith = (suffix) ->
  return this.indexOf(suffix, this.length - suffix.length) != -1

String.prototype.trim = ->
  return this.replace(/^\s+|\s+$/g,'')

Array.prototype.indexOf = (obj) ->
  for a, i in this
    if obj == a
      return i
  return -1


class Tsv
  @load: (filePath) ->
    file = new File(filePath)
    file.encoding = "UTF-8"
    file.open("r", "TEXT")
    body = []
    while(!file.eof)
      text = file.readln()
      elements = []
      for a in text.split('\t')
        elements.push(a.replace(/\n/g, " ").replace(/\r/g, " ").replace(/  /g, " "))
      body.push(elements)
    file.close()
    body


class Main
  run: ->
    root = app.activeDocument
    filePath = File.openDialog("tsv選択", "*.tsv")
    if filePath
      data = Tsv.load(filePath)
      @replace(root, data)

  replace: (root, dict) ->
    keyIndex = 0
    valueIndex = 0

    for e, index in dict[0]
      if e == 'KEY'
        keyIndex = index
      if e == 'VALUE'
        valueIndex = index

    if keyIndex == 0 && valueIndex == 0
      alert("1行目にKEY, VALUEが見つかりません。")
      return

    used = []
    for textFrame in root.textFrames
      continue if textFrame.locked
      continue if textFrame.visible
      text = textFrame.contents.replace(/\n/g, " ").replace(/\r/g, " ").replace(/  /g, " ")
      original = text
      for line, index in dict
        a = text
        text = text.replace(new RegExp(line[keyIndex], "g"), line[valueIndex])
        if a != text
          used.push(index)
      if text != original
        textFrame.contents = text

    warning = []
    for line, index in dict
      continue if used.indexOf(index) != -1
      warning.push("#{index}行目 - #{line[keyIndex]}")

    if warning.length > 0
      alert("使用されなかったデータがあります。。\n#{warning.join('\n')}")



main = new Main()
main.run()
alert('complete!')
