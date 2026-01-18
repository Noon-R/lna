# LNA for Godot

Godot向けのLNAライブラリ実装です（Godot 4.x対応）。

## インストール

1. `godot/addons/lna`フォルダをGodotプロジェクトの`addons`フォルダにコピー
2. Godot Editorで「プロジェクト」→「プロジェクト設定」→「プラグイン」からLNAを有効化
3. Autoloadで`LNAManager`を登録（`res://addons/lna/core/lna_manager.gd`）

## 使用方法

### 基本セットアップ

プロジェクト設定のAutoloadタブで以下を追加：
- `LNAManager`: `res://addons/lna/core/lna_manager.gd`

### 最小限の例

```gdscript
extends Node2D

func _ready():
    # Event subscription
    LNAManager.events.subscribe(GameEvents.SCENE_LOAD_COMPLETE, self, "_on_scene_loaded")

    # Input setup is done in Project Settings > Input Map

func _process(delta):
    if LNAManager.input.is_action_just_pressed(InputActions.JUMP):
        print("Jump!")

func _on_scene_loaded(data):
    print("Scene loaded!")
```

### シーン遷移

```gdscript
# Load a new scene
LNAManager.scene.load_scene("res://scenes/game_scene.tscn")

# Load with transition
var fade = preload("res://transitions/fade.tscn").instantiate()
LNAManager.scene.load_scene_with_transition("res://scenes/title.tscn", fade)
```

### ゲームフロー管理

```gdscript
# Change game state
LNAManager.game_flow.change_state(GameFlowManager.GameState.GAMEPLAY)

# Pause/Resume
LNAManager.game_flow.pause()
LNAManager.game_flow.resume()
```

## 実装状況

- [ ] SingletonBase / LNAManager
- [ ] StateMachine
- [ ] EventSystem
- [ ] InputManager
- [ ] SceneManager
- [ ] GameFlowManager
- [ ] AudioManager
- [ ] SaveDataManager
- [ ] ResourceManager
- [ ] Timer
- [ ] Tween
- [ ] ObjectPool
- [ ] UIManager
- [ ] DialogSystem
- [ ] TransitionEffect

## 詳細ドキュメント

各機能の詳細は[docs/godot](../docs/godot/)を参照してください。
