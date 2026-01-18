# LNA (Library for New Adventures)

Unity、Godot、Playdate向けのゲーム開発ライブラリ

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Status](https://img.shields.io/badge/status-in%20development-yellow.svg)

## 概要

LNAは、ゲーム開発で頻繁に必要となる機能を提供するライブラリです。
Unity、Godot、Playdateの3つのプラットフォームに対応し、各プラットフォームのベストプラクティスに従った実装を提供します。

## 特徴

- **マルチプラットフォーム対応**: Unity (C#)、Godot (GDScript)、Playdate (C)
- **即座に使える**: ゲーム開発で必須となる基本機能を提供
- **シンプルなAPI**: 学習コストが低く、直感的に使える
- **実戦的**: 実際のゲーム開発で必要な機能に特化

## サポートプラットフォーム

| プラットフォーム | 言語 | バージョン |
|-----------------|------|-----------|
| Unity | C# | 2021.3+ |
| Godot | GDScript | 4.x |
| Playdate | C | SDK 2.x+ |

## 提供機能

### 基礎システム
- ✅ **シングルトン管理** - 各マネージャーへの統一的なアクセス
- ✅ **StateMachine** - 汎用ステートマシン
- ✅ **EventSystem** - イベント駆動型の疎結合な通信

### コアマネージャー
- 🚧 **InputManager** - 入力の抽象化とアクションマッピング
- 🚧 **SceneManager** - シーン遷移管理
- 🚧 **GameFlowManager** - ゲーム全体のフロー制御
- 🚧 **AudioManager** - BGM・SE管理
- 🚧 **SaveDataManager** - セーブデータ管理

### ユーティリティ
- ⏳ **Timer** - タイマー・遅延実行
- ⏳ **Tween** - 値の補間・イージング
- ⏳ **ObjectPool** - オブジェクトプール

### UI
- ⏳ **UIManager** - UI管理
- ⏳ **DialogSystem** - メッセージ・選択肢表示
- ⏳ **TransitionEffect** - 画面遷移エフェクト

*凡例: ✅ 計画済み | 🚧 開発中 | ⏳ 未着手*

## クイックスタート

### Unity

```bash
# プロジェクトにコピー
cp -r unity /path/to/your/UnityProject/Assets/LNA
```

```csharp
using LNA;

// マネージャーへのアクセス
LNAManager.Input.GetActionDown("jump");
LNAManager.Scene.LoadScene("GameScene");
LNAManager.Audio.PlayBGM("theme");
```

詳細: [Unity実装ガイド](unity/README.md)

### Godot

```bash
# アドオンとしてインストール
cp -r godot/addons/lna /path/to/your/GodotProject/addons/
```

プロジェクト設定でプラグインを有効化し、LNAManagerをAutoloadに登録。

```gdscript
# マネージャーへのアクセス
LNAManager.input.is_action_just_pressed("jump")
LNAManager.scene.load_scene("res://scenes/game.tscn")
LNAManager.audio.play_bgm("theme")
```

詳細: [Godot実装ガイド](godot/README.md)

### Playdate

```bash
# プロジェクトにコピー
cp -r playdate /path/to/your/PlaydateProject/lna
```

```c
#include "lna/core/lna_manager.h"

// Initialize
lna_manager_init(pd);

// Use managers
lna_input_get_action_down(lna_get_input(), "jump");
lna_scene_load(lna_get_scene(), "game");
lna_audio_play_bgm(lna_get_audio(), "theme");

// Update every frame
lna_manager_update();
```

詳細: [Playdate実装ガイド](playdate/README.md)

## ドキュメント

- [プロジェクト概要](Claude.md) - プロジェクトの詳細な説明
- [ロードマップ](ROADMAP.md) - 実装計画とマイルストーン
- [実装計画](IMPLEMENTATION_PLAN.md) - 詳細なクラス設計と依存関係
- [Unity ドキュメント](docs/unity/) - Unity実装の詳細
- [Godot ドキュメント](docs/godot/) - Godot実装の詳細
- [Playdate ドキュメント](docs/playdate/) - Playdate実装の詳細

## サンプルプロジェクト

各プラットフォームのサンプルプロジェクトは `examples/` ディレクトリにあります。

- [Unity サンプル](examples/unity/)
- [Godot サンプル](examples/godot/)
- [Playdate サンプル](examples/playdate/)

## 開発状況

現在、Phase 1（基礎インフラ）の実装を進めています。

詳細は[ROADMAP.md](ROADMAP.md)を参照してください。

## ライセンス

MIT License

## コントリビューション

バグ報告、機能リクエスト、プルリクエストを歓迎します。

## 関連リンク

- [Unity](https://unity.com/)
- [Godot Engine](https://godotengine.org/)
- [Playdate](https://play.date/)
