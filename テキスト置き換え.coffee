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

IsPhotoshop = (BridgeTalk != null && BridgeTalk.appName == 'photoshop')

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
        text += " "
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

    replacedTextColor = new CMYKColor()
    replacedTextColor.black = 0
    replacedTextColor.cyan = 50
    replacedTextColor.magenta = 100
    replacedTextColor.yellow = 50

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

    used = []
    used.push(dict[0][keyIndex])

    # 文字列が長いものからヒットさせる
    dict.sort (a, b) -> b[keyIndex].length - a[keyIndex].length

    textFrames = root.textFrames
    textFrames = (textFrame for textFrame in root.layers when textFrame.kind == LayerKind.TEXT) if IsPhotoshop
    for textFrame in textFrames
      continue if textFrame.locked
      textFrame = textFrame.textItem if IsPhotoshop
      text = textFrame.contents.replace(/\n/g, " ").replace(/\r/g, " ").replace(/  /g, " ")
      replaced_texts = []
      for line, index in dict
        continue if line[keyIndex] == "" || line[valueIndex] == "" || line[keyIndex] == " " || line[valueIndex] == " "
        start_index = text.indexOf(line[keyIndex])
        if start_index != -1
          text = text.replace(line[keyIndex], line[valueIndex])

          # 先に後ろを置換してしまっていたらstart_indexをずらす
          for i in replaced_texts
            if i[0] > start_index
              i[0] += (line[valueIndex].length - line[keyIndex].length)
          replaced_texts.push([start_index, line[valueIndex].length])
          used.push(line[keyIndex])

      if replaced_texts.length > 0
        textFrame.contents = text

        unless IsPhotoshop
          textArtRange = textFrame.textRange
          for t in replaced_texts
            for i in [t[0]..(t[0] + t[1] - 1)]
              textArtRange.characters[i].fillColor = replacedTextColor

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
