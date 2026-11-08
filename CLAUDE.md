# npc-agency-rpg

GDQuest の Godot Open RPG（MIT, upstream: https://github.com/gdquest-demos/godot-open-rpg ,
取り込み元コミット d59f2f71bc046ac53239a4e590861269e7100a36）をベースにした、修士研究の実験用ゲーム。

## 研究の目的
- ゲーム NPC のエージェンシー（Gray らの心の知覚のうち agency）を操作し、ゲーム体験とプレイヤーによる NPC への「冷遇」（人間に対する振る舞いからの乖離）への影響を調べる。
- 評価指標：PXI と Godspeed。参加者間計画、クラウドソーシングで募集、オンライン・ブラウザでプレイ（約20分）。
- 具体的な NPC 操作はまだ未定。まずデフォルトのゲームを遊んでから決める。

## 実験用の改造で守ること
- 条件間でゲームの機能（プレイヤーの操作範囲、報酬、クエスト進行）を変えない。変えるのは NPC の振る舞いだけ。
- 条件間で台詞の量・性格・ストーリーの面白さが変わらないように注意する（交絡を避ける）。
- 実験条件は1か所のフラグ（例：autoload の設定値や URL パラメータ）で切り替えられるようにする。
- 参加者向けのテキストは日本語。
- 最終的に Web（HTML5）エクスポートしてブラウザで配布する。
- 上流のコードからの差分はできるだけ小さく、分かりやすく保つ。

## 技術メモ
- Godot 4.7.2 以上が必要（GL Compatibility レンダラ）。メインシーン：res://src/main.tscn
- 会話：Dialogic 2（addons/dialogic）。台詞は `.dtl`（タイムライン）、キャラは `.dch`。
- マップ：overworld/maps/{town,house,forest}。町の NPC は fan_of_four / monk / thief / warrior / wizard / smith / runner。
  - fan_interaction.gd, gang_of_four_conversation.gd, conversation_encounter.gd などがイベント処理。
- フィールドのコア：src/field（gamepieces, gameboard, cutscenes の Interaction / Trigger）。
- 戦闘：src/combat。
- 主な autoload：Camera, CombatEvents, FieldEvents, Gameboard, GamepieceRegistry, Music, Player, Transition, Dialogic。
- アセット：Kenney Tiny Town（CREDITS.md 参照）。

## これまでの改造（上流からの差分）
- 日本語化：台詞（.dtl）・キャラ表示名（.dch）・戦闘アクション名/説明（combat/battlers/*.tres）・UI ラベルを日本語に。
  - フォントは DotGothic16（OFL, assets/gui/font）。会話ウィンドウ・選択肢・エンディング・扉・戦闘ボタンは直接指定、
    それ以外（バイナリの .theme 経由のもの）は autoload `JapaneseFont`（src/common/japanese_font.gd）が
    起動時にフォールバックとして追加する。Web ではシステムフォントのフォールバックが効かないため必須。
- シナリオ完結：森のゴースト（GameEndTrigger, overworld/maps/forest/game_end_trigger.gd）が
  会話 → 戦闘（test_combat_arena2）→ 勝利後の会話（ghost_victory.dtl）→ エンディング画面、の流れに。
  負けたら ghost_loss.dtl のあと再戦（必ずクリアできる）。
- 台詞：直訳をやめ、目的が分かるように書き直し（ファンが「4人からサインを」と明確に依頼、進捗 {TokenCount} を表示、
  ヒント役の台詞で木・カギ・台座の順番を示す）。英雄の表示名に職業を付けた（武道家ウィッジ など）。
- 戦闘の味方：クマ・リスをやめ、主人公のロボット1人に（combat/battlers/robot：フィールドのドット絵を拡大した見た目、
  技はパンチ／集中／修理）。1人で勝てるよう敵を調整（bugcat の命中率 0→100・攻撃 30→10、wolf の全体攻撃 999→25）。
- エンディング画面の文言は実験用（「アンケートの画面にお戻りください」）。

## デモのシナリオ（概要）
主人公は小さなロボット。森のゴーストに呼ばれている。町では英雄パーティー Gang of Four（monk・thief・warrior・wizard）のサインを欲しがるファンのため、4人からコインを集めて渡し、杖をもらう。家の台座パズル（runner のヒント）を解き、森でゴーストと戦って終了。
