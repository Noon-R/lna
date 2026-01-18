# LNA (Library for New Adventures)

## プロジェクト概要

Unity、Godot、Playdate向けのゲーム開発用ライブラリプロジェクトです。
ゲーム開発で共通して必要となる機能やマネージャーを各プラットフォーム向けに実装し、開発効率を向上させることを目的としています。

## 目的

- ゲーム開発で頻繁に使用される基本機能の実装を提供
- 各エンジン/プラットフォームのベストプラクティスに従った実装
- 再利用可能で保守性の高いコードベースの構築

## サポートプラットフォームと言語

| プラットフォーム | 言語 | ディレクトリ |
|-----------------|------|-------------|
| Unity | C# | `unity/` |
| Godot | GDScript | `godot/` |
| Playdate | C | `playdate/` |

## 提供機能（予定）

### コア機能
- **SceneManager**: シーン遷移管理
- **AudioManager**: サウンド・BGM管理
- **SaveDataManager**: セーブデータの読み書き
- **InputManager**: 入力管理の抽象化
- **ResourceManager**: リソースの読み込み・キャッシュ管理

### ユーティリティ
- **Timer**: タイマー機能
- **Tween**: イージング・補間機能
- **ObjectPool**: オブジェクトプール
- **EventSystem**: イベント通知システム
- **StateMachine**: 汎用ステートマシン

### UI関連
- **UIManager**: UI表示管理
- **DialogSystem**: ダイアログ・メッセージ表示
- **TransitionEffect**: 画面遷移エフェクト

## プロジェクト構造

```
lna/
├── unity/              # Unity向け実装（C#）
│   ├── Core/          # コア機能
│   ├── Utilities/     # ユーティリティ
│   └── UI/            # UI関連
├── godot/             # Godot向け実装（GDScript）
│   ├── addons/lna/    # Godotアドオン形式
│   │   ├── core/
│   │   ├── utilities/
│   │   └── ui/
│   └── plugin.cfg
├── playdate/          # Playdate向け実装（C）
│   ├── src/           # ソースコード
│   │   ├── core/
│   │   ├── utilities/
│   │   └── ui/
│   └── include/       # ヘッダーファイル
├── docs/              # ドキュメント
│   ├── unity/
│   ├── godot/
│   └── playdate/
├── examples/          # サンプルプロジェクト
│   ├── unity/
│   ├── godot/
│   └── playdate/
└── tests/             # テストコード
    ├── unity/
    ├── godot/
    └── playdate/
```

## 開発ガイドライン

### 命名規則

**Unity (C#)**
- クラス名: PascalCase（例: `SceneManager`）
- メソッド名: PascalCase（例: `LoadScene`）
- 変数名: camelCase（例: `currentScene`）
- 定数: UPPER_SNAKE_CASE（例: `MAX_SCENES`）

**Godot (GDScript)**
- クラス名: PascalCase（例: `SceneManager`）
- メソッド名: snake_case（例: `load_scene`）
- 変数名: snake_case（例: `current_scene`）
- 定数: UPPER_SNAKE_CASE（例: `MAX_SCENES`）

**Playdate (C)**
- 型名: PascalCase（例: `SceneManager`）
- 関数名: lna_module_function形式（例: `lna_scene_load`）
- 変数名: snake_case（例: `current_scene`）
- 定数: UPPER_SNAKE_CASE（例: `LNA_MAX_SCENES`）

### コーディング規約

1. **各プラットフォームのベストプラクティスに従う**
   - Unity: Unityの標準的なパターンとライフサイクルを尊重
   - Godot: ノードシステムとシグナルを活用
   - Playdate: メモリ効率を重視した実装

2. **シンプルで読みやすいコード**
   - 過度な抽象化を避ける
   - 明確な変数名と関数名を使用
   - 必要に応じてコメントを追加

3. **エラーハンドリング**
   - エラーは適切にハンドリング
   - デバッグに有用なログ出力

4. **ドキュメント**
   - 各機能にはREADMEとサンプルコードを用意
   - APIドキュメントを整備

## 使用方法

各プラットフォームの詳細な使用方法は、以下のドキュメントを参照してください：

- [Unity実装ガイド](docs/unity/README.md)
- [Godot実装ガイド](docs/godot/README.md)
- [Playdate実装ガイド](docs/playdate/README.md)

## ライセンス

MIT License

## 貢献

このプロジェクトへの貢献を歓迎します。
バグ報告、機能リクエスト、プルリクエストなどお気軽にお寄せください。

## 開発状況

現在開発中のプロジェクトです。
実装の優先順位と進捗は [ROADMAP.md](ROADMAP.md) を参照してください。
