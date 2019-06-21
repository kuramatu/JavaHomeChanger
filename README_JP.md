# JavaHomeChanger (JHC)

このツールは、環境変数「JAVA_HOME」の値を変更します。

ツールの利用には管理者権限での実行が必要です。



## 説明

インストールされているJDKを「JAVA_HOME」変更の選択肢として検索し表示します。

デフォルトでJDKを検索するフォルダは、"C:\Program Files\Java\"と"C:\Program Files (x86)\Java\"となります。



## インストール

1. "jhc.bat"および"mjl.bat"ファイルをダウンロードしてください。(ダウンロードした2ファイルは同じフォルダに配置してください)

2. ダウンロードした2ファイルが配置されたフォルダ(JHC_HOME)にPATHを通してください。



**注意**
 環境変数の「PATH」に「%JAVA_HOME%\bin」を追加していない場合は、追加してください。



## 使用方法

1. コマンドプロンプトを管理者権限で実行する
2. jhc [option]

	- `jhc`  選択したJDKに環境変数「JAVA_HOME」の値を変更します。

	- `jhc update`  表示されるJDKの選択肢を更新する場合に使用します。(新たなJDKをインストールした、既存のJDKをアンインストールした、"SearchTargetDirectories.conf"ファイルをカスタマイズした場合)



## カスタマイズ

デフォルト検索フォルダ以外のフォルダにJDKがインストールされている場合は、検索対象フォルダを"SearchTargetDirectories.conf"ファイルに追加してください。

"SearchTargetDirectories.conf"ファイルは"JHC_HOME\conf\"以下にあります。



## Licence

[MIT](https://github.com/kuramatu/JavaHomeChanger/blob/master/LICENSE)



## Author

[kuramatu](https://github.com/kuramatu)