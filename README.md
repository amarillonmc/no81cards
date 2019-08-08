# ＳＸ企划 - Ｎｏ．８１服务器
卡片及配置存放用

## 数据结构 ##
``/expansions``

卡片数据目录，本服使用的cdb文件名为``no81.cdb``，为确保文件完整，请将卡片图片一并上传到``/pic``目录下。

``/sound``

卡片BGM/音效目录，不懂的群里面问。

``/others``

服务器部分资源用目录，包含以下内容：

``dialogues.json`` - 召唤词（OT卡）

``dialogues-custom.json`` - 召唤词（DIY卡）

``tips.json`` - 服务器空闲时Ticker

``words.json`` - 决斗者加入服务器时宣告

## 如何投稿（上级者向） ##
如同A-B-C-D一样简单！

Clone-Modify-Push-PR！

1. 先clone本repo

2. 将你的卡片cdb内容整合进``no81.cdb``，而后将卡图数据和脚本数据也放入对应目录。


2.5.如果你想给自己的卡添加召唤词，请按照格式修改``dialogues-custom.json``，但修改格式错误将会导致你的修改全部被退回。 

3. 将你的更改Push到你刚才clone下的repo中。

4. 发一个PR，然后交叉手指祈祷你的卡能过。

5. 如果过了，谢天谢地。如果没过，大侠请重新来过。

无法理解上述内容的，请在QQ群或者论坛上进行投稿，让专人来负责文件整合。

## 其他 ##
This area is intentionally left blank.