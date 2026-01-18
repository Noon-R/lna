# LNA Development Roadmap

## 実装優先順位と依存関係

このドキュメントでは、LNAライブラリの実装計画と各機能の優先順位を定義します。

## Phase 1: 基礎インフラ（Foundation）

これらは他の全ての機能の基盤となります。

### 1.1 シングルトンシステム
- **Unity**: MonoBehaviourベースのシングルトンベースクラス
- **Godot**: AutoloadとNodeベースのシングルトンパターン
- **Playdate**: グローバルインスタンス管理

**実装内容:**
- シングルトンベースクラス/パターン
- シングルトンアクセサ（各Managerへの統一アクセス）
- 初期化/破棄の管理

**依存:** なし
**被依存:** 全てのManager

### 1.2 StateMachine（汎用ステートマシン）
- 状態遷移の基本システム
- GameFlowManager、SceneManagerなどで使用

**実装内容:**
- State基底クラス
- StateMachine本体
- 状態遷移管理
- Enter/Update/Exit のライフサイクル

**依存:** なし
**被依存:** GameFlowManager, SceneManager, その他状態管理が必要な機能

### 1.3 EventSystem（イベント通知システム）
- 疎結合なコンポーネント間通信
- 各Manager間の連携に使用

**実装内容:**
- イベントディスパッチャー
- イベントリスナー登録/解除
- 型付きイベントサポート

**依存:** シングルトンシステム
**被依存:** 全てのManager

## Phase 2: コアマネージャー（Core Managers）

ゲーム開発で必須となる基本的なマネージャー群。

### 2.1 InputManager（入力管理）
- キーボード、マウス、ゲームパッド、タッチ入力の抽象化
- アクションマッピング

**実装内容:**
- 入力の抽象化レイヤー
- アクションマッピング（ジャンプ、移動など）
- 入力バッファリング
- プラットフォーム別入力対応

**依存:** シングルトンシステム, EventSystem
**被依存:** GameFlowManager, ゲームロジック全般

### 2.2 SceneManager（シーン遷移管理）
- シーン/レベルの読み込みと遷移
- ローディング画面との連携

**実装内容:**
- シーン読み込み/アンロード
- 非同期ロード対応
- トランジションエフェクトとの連携
- シーンスタック管理（戻る機能）

**依存:** シングルトンシステム, EventSystem, StateMachine
**被依存:** GameFlowManager

### 2.3 GameFlowManager（ゲームフロー管理）
- ゲーム全体の状態管理（タイトル、ゲームプレイ、ポーズ、ゲームオーバーなど）
- StateMachineを活用

**実装内容:**
- ゲーム状態の定義と管理
- 状態遷移ロジック
- ポーズ/リジューム機能
- ゲームループ制御

**依存:** シングルトンシステム, StateMachine, EventSystem, InputManager, SceneManager
**被依存:** ゲームロジック全体

## Phase 3: メディアマネージャー（Media Managers）

### 3.1 AudioManager（サウンド管理）
- BGM、SE、ボイスの再生管理
- ボリューム調整、フェード機能

**実装内容:**
- BGM再生（ループ、フェードイン/アウト）
- SE再生（複数同時再生、優先度管理）
- ボリューム管理（マスター、BGM、SE別）
- オーディオミキシング

**依存:** シングルトンシステム, EventSystem
**被依存:** GameFlowManager, UI

### 3.2 ResourceManager（リソース管理）
- アセットの読み込みとキャッシュ管理
- メモリ管理

**実装内容:**
- リソースロード/アンロード
- キャッシュ管理
- 非同期ロード
- リソース参照カウント

**依存:** シングルトンシステム
**被依存:** SceneManager, AudioManager, UI

## Phase 4: データ永続化（Data Persistence）

### 4.1 SaveDataManager（セーブデータ管理）
- セーブデータの読み書き
- 暗号化、バージョン管理

**実装内容:**
- セーブ/ロード機能
- 複数スロット対応
- JSON/バイナリ形式対応
- データ整合性チェック
- オートセーブ機能

**依存:** シングルトンシステム, EventSystem
**被依存:** ゲームデータ管理

## Phase 5: ユーティリティ（Utilities）

### 5.1 Timer（タイマー機能）
- 時間計測、遅延実行、定期実行

**実装内容:**
- カウントダウン/カウントアップタイマー
- 遅延実行（Delay）
- 定期実行（Repeat）
- ポーズ/リジューム対応

**依存:** なし（軽量な独立機能）
**被依存:** ゲームロジック、UI

### 5.2 Tween（補間・イージング）
- 値の補間、イージング関数
- アニメーション制御

**実装内容:**
- 各種イージング関数（Linear, EaseIn/Out, Bounce, Elasticなど）
- チェーン・並列実行
- コールバック（OnComplete, OnUpdate）
- ループ、ヨーヨー再生

**依存:** Timer
**被依存:** UI, ゲームエフェクト

### 5.3 ObjectPool（オブジェクトプール）
- オブジェクトの再利用によるメモリ最適化
- 特にPlaydateで重要

**実装内容:**
- プール管理
- 自動拡張
- オブジェクト初期化/リセット
- プールサイズ制限

**依存:** なし
**被依存:** 弾幕、エフェクト、敵キャラなど大量生成が必要な要素

## Phase 6: UI システム（UI System）

### 6.1 UIManager（UI表示管理）
- UI要素の表示/非表示管理
- UIスタック管理

**実装内容:**
- UI表示/非表示制御
- UIスタック（モーダル管理）
- UIトランジション
- フォーカス管理

**依存:** シングルトンシステム, EventSystem, Tween
**被依存:** DialogSystem

### 6.2 DialogSystem（ダイアログ・メッセージ）
- テキスト表示、選択肢、メッセージウィンドウ

**実装内容:**
- テキスト送り（タイプライター効果）
- 選択肢表示
- スキップ/オート再生
- キャラクター名、顔グラ表示

**依存:** UIManager, InputManager
**被依存:** ゲームシナリオ

### 6.3 TransitionEffect（画面遷移エフェクト）
- フェード、ワイプなどの画面遷移演出

**実装内容:**
- フェードイン/アウト
- ワイプ（上下左右、円形）
- カスタムトランジション
- SceneManagerとの連携

**依存:** Tween
**被依存:** SceneManager, UIManager

## 実装スケジュール

### Milestone 1: 基礎インフラ完成
- [ ] シングルトンシステム（Unity, Godot, Playdate）
- [ ] StateMachine（Unity, Godot, Playdate）
- [ ] EventSystem（Unity, Godot, Playdate）
- [ ] 基本的なサンプルコードとドキュメント

**完了条件:** 3プラットフォームで基礎機能が動作し、サンプルプロジェクトで検証完了

### Milestone 2: コアマネージャー完成
- [ ] InputManager（Unity, Godot, Playdate）
- [ ] SceneManager（Unity, Godot, Playdate）
- [ ] GameFlowManager（Unity, Godot, Playdate）
- [ ] 統合サンプル（シーン遷移 + ゲームフロー）

**完了条件:** ゲームの基本的なフロー（タイトル→ゲーム→結果）が実現可能

### Milestone 3: メディア・データ完成
- [ ] AudioManager（Unity, Godot, Playdate）
- [ ] ResourceManager（Unity, Godot, Playdate）
- [ ] SaveDataManager（Unity, Godot, Playdate）

**完了条件:** サウンド再生とデータ保存が可能なデモゲーム作成

### Milestone 4: ユーティリティ完成
- [ ] Timer（Unity, Godot, Playdate）
- [ ] Tween（Unity, Godot, Playdate）
- [ ] ObjectPool（Unity, Godot, Playdate）

**完了条件:** アニメーションやエフェクトを含むゲームが作成可能

### Milestone 5: UIシステム完成
- [ ] UIManager（Unity, Godot, Playdate）
- [ ] DialogSystem（Unity, Godot, Playdate）
- [ ] TransitionEffect（Unity, Godot, Playdate）

**完了条件:** フルフィーチャーのゲームが作成可能

## プラットフォーム実装方針

各機能について、以下の順序で実装を進めます：

1. **Unity（C#）** - リファレンス実装として最初に実装
2. **Godot（GDScript）** - Unityの設計を参考に、Godot流にアレンジ
3. **Playdate（C）** - メモリ制約を考慮した実装

ただし、機能によっては並行実装も検討します。

## 次のアクション

1. 詳細な実装計画資料（IMPLEMENTATION_PLAN.md）の作成
2. プロジェクト構造の作成
3. Milestone 1の実装開始
