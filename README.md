# illustrator_replace

aiファイル内のテキストアイテムのテキストをtsvに従って置換してくれるスクリプトです。

# インストール方法

以下のファイルをダウンロードし、 `/Applications/Adobe Illustrator CC */Presets.localized/*/Scripts` あたりに入れてください。  
例えばIllustrator CC 2018の日本語環境であれば  
`/Applications/Adobe Illustrator CC 2018/Presets.localized/ja_JP/スクリプト` になります。  

https://raw.githubusercontent.com/kyubuns/illustrator_replace/master/%E3%83%86%E3%82%AD%E3%82%B9%E3%83%88%E7%BD%AE%E3%81%8D%E6%8F%9B%E3%81%88.jsx

# 使い方

## はじめに

このようなイラストレーターのデータがあったとします。

![monosnap 2018-05-10 10-54-28](https://user-images.githubusercontent.com/961165/39848184-85831f40-5440-11e8-9b5b-b9cb58792a34.png)

## 変換データを作成

GoogleSpreadsheetなどを使用して  
1行目: KEY, VALUE というテキスト  
2行目以降: KEYの列に変換前のテキスト、VALUEの列に変換後のテキストを書いていきます。

![monosnap 2018-05-10 10-55-06](https://user-images.githubusercontent.com/961165/39848200-9be23b5e-5440-11e8-8a85-97f4367941ec.png)

## tsvに変換

tsvに変換します。
この時、ファイル名が日本語だと実行に失敗することがあるので、英語名に治しておいて下さい。

![39848255-dc589e6c-5440-11e8-8297-36b2356f7b61](https://user-images.githubusercontent.com/961165/39848400-b84b05d6-5441-11e8-9c3d-64c4e50dfd3c.png)

## スクリプトを実行

illustrator上からスクリプトを実行します。  
ダイアログが表示されるので、先程ダウンロードしたtsvを指定してください。  

![monosnap 2018-05-10 10-57-42](https://user-images.githubusercontent.com/961165/39848271-fc4374ae-5440-11e8-919f-4b84149714d2.png)

## 結果

テキストが置換されます。

![monosnap 2018-05-10 11-00-41](https://user-images.githubusercontent.com/961165/39848343-64b1f75e-5441-11e8-9dbe-2c7400cc6d50.png)
