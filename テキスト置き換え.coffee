String.prototype.startsWith = (str) ->
  return this.slice(0, str.length) == str

String.prototype.endsWith = (suffix) ->
  return this.indexOf(suffix, this.length - suffix.length) != -1

String.prototype.trim = ->
  return this.replace(/^\s+|\s+$/g,'')

String.prototype.count = (str) ->
  i = 0
  for a in this
    i += 1 if a == str
  i

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
    element_num = 0

    # セル内に改行が入っていることを考慮して
    # 1行目を基準に要素数が集まるまでテキストをつなげる
    while(!file.eof)
      text = file.readln()
      element_num = text.count('\t') if element_num == 0
      while(element_num > text.count('\t'))
        text += file.readln()

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
    lineIndex = dict[0].length

    for e, index in dict[0]
      if e == 'KEY' || e == 'Key' || e == 'key'
        keyIndex = index
      if e == 'VALUE' || e == 'Value' || e == 'value'
        valueIndex = index

    if keyIndex == 0 && valueIndex == 0
      alert("1行目にKEY, VALUEが見つかりません。")
      return

    for line, index in dict
      line[lineIndex] = index + 1

    # 文字列が長いものからヒットさせる
    dict.sort (a, b) -> b[keyIndex].length - a[keyIndex].length

    used = []
    for textFrame in root.textFrames
      continue if textFrame.locked
      continue if textFrame.visible
      text = textFrame.contents.replace(/\n/g, " ").replace(/\r/g, " ").replace(/  /g, " ")
      original = text
      for line, index in dict
        a = text
        continue if line[keyIndex] == "" || line[valueIndex] == ""
        text = text.replace(line[keyIndex], line[valueIndex])
        if a != text
          used.push(line[keyIndex])
      if text != original
        textFrame.contents = text

    dict.sort (a, b) -> a[lineIndex] - b[lineIndex]

    warning = []
    for line, index in dict
      continue if used.indexOf(line[keyIndex]) != -1
      warning.push("#{line[lineIndex]}行目 - #{line[keyIndex]}")

    if warning.length > 0
      alert("使用されなかったデータがあります。\n#{warning.join('\n')}")



main = new Main()
main.run()
alert('complete!')
