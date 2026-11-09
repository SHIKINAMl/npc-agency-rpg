# npc-agency-rpg

ゲーム NPC のエージェンシー（心の知覚のうち「行為する主体」としての知覚）が、
ゲーム体験とプレイヤーの NPC に対する振る舞いにどう影響するかを調べるための、修士研究の実験用ゲームです。

▶ **ブラウザで遊ぶ：https://shikinaml.github.io/npc-agency-rpg/**
（PC のブラウザ推奨。所要時間は約20分）

## あらすじ
主人公は小さなロボット。長い眠りから目覚めると、自分を作った技師が「森の奥で待っている」と呼んでいる。
町の人々の話を聞き、英雄パーティーのファンの頼みをかなえ、留守にしている魔法使いマチルダの家の仕掛けを解いて、森の奥を目指そう。

## 操作方法
| 操作 | キー / マウス |
|---|---|
| 移動 | 矢印キー / WASD、またはマウスで行き先をクリック |
| 話しかける・調べる | スペース |
| 会話を進める | スペース / Enter / X、またはクリック |
| 選択肢・戦闘メニューの決定 | Enter / スペース |
| 戻る（戦闘メニュー） | Esc |

## 開発者向け
- エンジン：Godot 4.7.2 以上（GL Compatibility）。`project.godot` を Godot で開き、F5 で実行します。
- 会話システム：Dialogic 2（`addons/dialogic`）。台詞は `overworld/maps/**/*.dtl` にあります。
- Web 版：`claude/fervent-brown-71kzwt` / `main` ブランチへ push すると、GitHub Actions
  （`.github/workflows/deploy-web.yml`）が Web 版を書き出して GitHub Pages に公開します。
  リポジトリの Settings → Pages → Source を「GitHub Actions」にしておく必要があります。
- 研究の方針・実験用改造のルール・上流からの変更点は [CLAUDE.md](CLAUDE.md) にまとめています。

## クレジット・ライセンス
- 本プロジェクトは GDQuest の [Godot Open RPG](https://github.com/gdquest-demos/godot-open-rpg)（MIT License,
  取り込み元コミット `d59f2f7`）をもとに改造したものです。ライセンスは [LICENSE](LICENSE) を参照してください。
- 素材（Kenney Tiny Town ほか、日本語フォント DotGothic16）のクレジットは [CREDITS.md](CREDITS.md) を参照してください。
