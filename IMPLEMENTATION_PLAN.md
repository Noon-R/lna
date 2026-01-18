# LNA Implementation Plan

このドキュメントでは、各機能の詳細な実装計画、クラス設計、メソッド定義、依存関係を定義します。

---

## Phase 1: 基礎インフラ

### 1.1 シングルトンシステム

#### Unity (C#)

**ファイル:** `unity/Core/Singleton.cs`

```csharp
public class Singleton<T> : MonoBehaviour where T : MonoBehaviour
{
    // Properties
    private static T _instance;
    public static T Instance { get; }

    // Methods
    protected virtual void Awake()
    protected virtual void OnDestroy()
}
```

**ファイル:** `unity/Core/LNAManager.cs`

```csharp
public static class LNAManager
{
    // Accessors
    public static InputManager Input { get; }
    public static SceneManager Scene { get; }
    public static AudioManager Audio { get; }
    public static SaveDataManager SaveData { get; }
    public static GameFlowManager GameFlow { get; }
    public static EventSystem Events { get; }

    // Methods
    public static void Initialize()
    public static void Shutdown()
}
```

**依存関係:**
- なし（全ての基礎）

---

#### Godot (GDScript)

**ファイル:** `godot/addons/lna/core/singleton_base.gd`

```gdscript
extends Node
class_name SingletonBase

# Properties
static var _instances := {}

# Methods
func _ready()
func _notification(what)
static func get_instance(script_class)
```

**ファイル:** `godot/addons/lna/core/lna_manager.gd`

```gdscript
extends Node
# Autoload として登録

# Accessors
var input: InputManager
var scene: SceneManager
var audio: AudioManager
var save_data: SaveDataManager
var game_flow: GameFlowManager
var events: EventSystem

# Methods
func _ready()
func shutdown()
```

**依存関係:**
- なし

---

#### Playdate (C)

**ファイル:** `playdate/include/lna/core/lna_manager.h`

```c
typedef struct LNAManager LNAManager;

// Global instance accessor
LNAManager* lna_get_manager(void);

// Individual manager accessors
InputManager* lna_get_input(void);
SceneManager* lna_get_scene(void);
AudioManager* lna_get_audio(void);
SaveDataManager* lna_get_savedata(void);
GameFlowManager* lna_get_gameflow(void);
EventSystem* lna_get_events(void);

// Lifecycle
void lna_manager_init(PlaydateAPI* pd);
void lna_manager_update(void);
void lna_manager_shutdown(void);
```

**依存関係:**
- PlaydateAPI

---

### 1.2 StateMachine

#### Unity (C#)

**ファイル:** `unity/Core/StateMachine/IState.cs`

```csharp
public interface IState
{
    void Enter();
    void Update();
    void FixedUpdate();
    void Exit();
}
```

**ファイル:** `unity/Core/StateMachine/StateMachine.cs`

```csharp
public class StateMachine<T> where T : IState
{
    // Properties
    public T CurrentState { get; private set; }
    public T PreviousState { get; private set; }

    // Methods
    public void Initialize(T startingState)
    public void ChangeState(T newState)
    public void Update()
    public void FixedUpdate()
}
```

**依存関係:**
- なし

**被依存:**
- GameFlowManager
- SceneManager
- その他状態管理が必要なゲームロジック

---

#### Godot (GDScript)

**ファイル:** `godot/addons/lna/core/state_machine/state_base.gd`

```gdscript
extends Node
class_name StateBase

# Virtual methods
func enter() -> void
func update(delta: float) -> void
func physics_update(delta: float) -> void
func exit() -> void
func handle_input(event: InputEvent) -> void
```

**ファイル:** `godot/addons/lna/core/state_machine/state_machine.gd`

```gdscript
extends Node
class_name StateMachine

# Properties
var current_state: StateBase
var previous_state: StateBase

# Methods
func initialize(starting_state: StateBase) -> void
func change_state(new_state: StateBase) -> void
func _process(delta: float) -> void
func _physics_process(delta: float) -> void
func _input(event: InputEvent) -> void
```

**依存関係:**
- なし

---

#### Playdate (C)

**ファイル:** `playdate/include/lna/core/state_machine.h`

```c
typedef struct State State;
typedef struct StateMachine StateMachine;

// State callbacks
typedef void (*StateEnterFunc)(State* state);
typedef void (*StateUpdateFunc)(State* state);
typedef void (*StateExitFunc)(State* state);

struct State {
    const char* name;
    void* data;
    StateEnterFunc enter;
    StateUpdateFunc update;
    StateExitFunc exit;
};

// StateMachine
StateMachine* lna_statemachine_new(void);
void lna_statemachine_free(StateMachine* sm);
void lna_statemachine_init(StateMachine* sm, State* starting_state);
void lna_statemachine_change(StateMachine* sm, State* new_state);
void lna_statemachine_update(StateMachine* sm);
State* lna_statemachine_get_current(StateMachine* sm);
State* lna_statemachine_get_previous(StateMachine* sm);
```

**依存関係:**
- なし

---

### 1.3 EventSystem

#### Unity (C#)

**ファイル:** `unity/Core/EventSystem/EventSystem.cs`

```csharp
public class EventSystem : Singleton<EventSystem>
{
    // Delegate types
    public delegate void EventCallback();
    public delegate void EventCallback<T>(T data);

    // Methods
    public void Subscribe(string eventName, EventCallback callback)
    public void Subscribe<T>(string eventName, EventCallback<T> callback)
    public void Unsubscribe(string eventName, EventCallback callback)
    public void Unsubscribe<T>(string eventName, EventCallback<T> callback)
    public void Trigger(string eventName)
    public void Trigger<T>(string eventName, T data)
    public void Clear()
}
```

**共通イベント定義:**
```csharp
public static class GameEvents
{
    // Scene events
    public const string SCENE_LOAD_START = "scene.load.start";
    public const string SCENE_LOAD_COMPLETE = "scene.load.complete";

    // Game flow events
    public const string GAME_STATE_CHANGED = "gameflow.state.changed";
    public const string GAME_PAUSED = "gameflow.paused";
    public const string GAME_RESUMED = "gameflow.resumed";

    // Audio events
    public const string BGM_STARTED = "audio.bgm.started";
    public const string BGM_STOPPED = "audio.bgm.stopped";

    // Input events
    public const string INPUT_ACTION_TRIGGERED = "input.action.triggered";
}
```

**依存関係:**
- Singleton

**被依存:**
- 全てのManager

---

#### Godot (GDScript)

**ファイル:** `godot/addons/lna/core/event_system.gd`

```gdscript
extends Node
class_name EventSystem

# Internal storage
var _events := {}

# Methods
func subscribe(event_name: String, target: Object, method: String) -> void
func unsubscribe(event_name: String, target: Object, method: String) -> void
func trigger(event_name: String, data = null) -> void
func clear() -> void
func clear_event(event_name: String) -> void
```

**ファイル:** `godot/addons/lna/core/game_events.gd`

```gdscript
extends Object
class_name GameEvents

# Scene events
const SCENE_LOAD_START := "scene.load.start"
const SCENE_LOAD_COMPLETE := "scene.load.complete"

# Game flow events
const GAME_STATE_CHANGED := "gameflow.state.changed"
const GAME_PAUSED := "gameflow.paused"
const GAME_RESUMED := "gameflow.resumed"

# Audio events
const BGM_STARTED := "audio.bgm.started"
const BGM_STOPPED := "audio.bgm.stopped"

# Input events
const INPUT_ACTION_TRIGGERED := "input.action.triggered"
```

**依存関係:**
- なし

---

#### Playdate (C)

**ファイル:** `playdate/include/lna/core/event_system.h`

```c
typedef struct EventSystem EventSystem;
typedef void (*EventCallback)(void* data);

// Lifecycle
EventSystem* lna_events_new(void);
void lna_events_free(EventSystem* events);

// Subscribe/Unsubscribe
void lna_events_subscribe(EventSystem* events, const char* event_name, EventCallback callback);
void lna_events_unsubscribe(EventSystem* events, const char* event_name, EventCallback callback);

// Trigger
void lna_events_trigger(EventSystem* events, const char* event_name, void* data);
void lna_events_clear(EventSystem* events);

// Common event names (constants)
#define LNA_EVENT_SCENE_LOAD_START "scene.load.start"
#define LNA_EVENT_SCENE_LOAD_COMPLETE "scene.load.complete"
#define LNA_EVENT_GAME_STATE_CHANGED "gameflow.state.changed"
#define LNA_EVENT_GAME_PAUSED "gameflow.paused"
#define LNA_EVENT_GAME_RESUMED "gameflow.resumed"
#define LNA_EVENT_BGM_STARTED "audio.bgm.started"
#define LNA_EVENT_BGM_STOPPED "audio.bgm.stopped"
#define LNA_EVENT_INPUT_ACTION "input.action.triggered"
```

**依存関係:**
- なし

---

## Phase 2: コアマネージャー

### 2.1 InputManager

#### Unity (C#)

**ファイル:** `unity/Core/InputManager.cs`

```csharp
public class InputManager : Singleton<InputManager>
{
    // Action mapping
    private Dictionary<string, KeyCode[]> _actionMap;

    // Properties
    public Vector2 MoveInput { get; private set; }

    // Methods
    public void RegisterAction(string actionName, params KeyCode[] keys)
    public void UnregisterAction(string actionName)
    public bool GetAction(string actionName)
    public bool GetActionDown(string actionName)
    public bool GetActionUp(string actionName)

    // Axis
    public float GetAxis(string axisName)
    public Vector2 GetVector(string horizontalAxis, string verticalAxis)

    // Raw input
    public bool GetKey(KeyCode key)
    public bool GetKeyDown(KeyCode key)
    public bool GetKeyUp(KeyCode key)
    public Vector2 GetMousePosition()

    // Internal
    void Update()
}
```

**共通アクション定義:**
```csharp
public static class InputActions
{
    public const string JUMP = "jump";
    public const string ATTACK = "attack";
    public const string INTERACT = "interact";
    public const string PAUSE = "pause";
    public const string CONFIRM = "confirm";
    public const string CANCEL = "cancel";
    public const string MOVE_UP = "move_up";
    public const string MOVE_DOWN = "move_down";
    public const string MOVE_LEFT = "move_left";
    public const string MOVE_RIGHT = "move_right";
}
```

**依存関係:**
- Singleton
- EventSystem

**被依存:**
- GameFlowManager
- ゲームロジック全般

---

#### Godot (GDScript)

**ファイル:** `godot/addons/lna/core/input_manager.gd`

```gdscript
extends Node
class_name InputManager

# Action mapping (Godotは InputMap を使用するので薄いラッパー)
var _action_buffer := {}

# Methods
func is_action_pressed(action: String) -> bool
func is_action_just_pressed(action: String) -> bool
func is_action_just_released(action: String) -> bool

# Vector input
func get_vector(negative_x: String, positive_x: String, negative_y: String, positive_y: String) -> Vector2
func get_axis(negative: String, positive: String) -> float

# Buffered input (格ゲーのようなコマンド入力用)
func buffer_action(action: String, buffer_time: float = 0.1) -> void
func is_action_buffered(action: String) -> bool

# Internal
func _process(delta: float) -> void
func _input(event: InputEvent) -> void
```

**ファイル:** `godot/addons/lna/core/input_actions.gd`

```gdscript
extends Object
class_name InputActions

const JUMP := "jump"
const ATTACK := "attack"
const INTERACT := "interact"
const PAUSE := "pause"
const CONFIRM := "confirm"
const CANCEL := "cancel"
const MOVE_UP := "move_up"
const MOVE_DOWN := "move_down"
const MOVE_LEFT := "move_left"
const MOVE_RIGHT := "move_right"
```

**依存関係:**
- EventSystem

---

#### Playdate (C)

**ファイル:** `playdate/include/lna/core/input_manager.h`

```c
typedef struct InputManager InputManager;

typedef enum {
    LNA_BUTTON_A,
    LNA_BUTTON_B,
    LNA_BUTTON_UP,
    LNA_BUTTON_DOWN,
    LNA_BUTTON_LEFT,
    LNA_BUTTON_RIGHT,
    LNA_BUTTON_COUNT
} LNAButton;

// Lifecycle
InputManager* lna_input_new(PlaydateAPI* pd);
void lna_input_free(InputManager* input);
void lna_input_update(InputManager* input);

// Button state
int lna_input_is_pressed(InputManager* input, LNAButton button);
int lna_input_is_just_pressed(InputManager* input, LNAButton button);
int lna_input_is_just_released(InputManager* input, LNAButton button);

// Crank (Playdate specific)
float lna_input_get_crank_angle(InputManager* input);
float lna_input_get_crank_change(InputManager* input);
int lna_input_is_crank_docked(InputManager* input);

// Action mapping
void lna_input_register_action(InputManager* input, const char* action_name, LNAButton button);
int lna_input_get_action(InputManager* input, const char* action_name);
int lna_input_get_action_down(InputManager* input, const char* action_name);
```

**依存関係:**
- EventSystem
- PlaydateAPI

---

### 2.2 SceneManager

#### Unity (C#)

**ファイル:** `unity/Core/SceneManager.cs`

```csharp
public class SceneManager : Singleton<SceneManager>
{
    // Properties
    public string CurrentSceneName { get; private set; }
    public bool IsLoading { get; private set; }

    // Scene stack (戻る機能用)
    private Stack<string> _sceneHistory;

    // Methods
    public void LoadScene(string sceneName, bool addToHistory = true)
    public void LoadSceneAsync(string sceneName, Action onComplete = null)
    public void ReloadCurrentScene()
    public void GoBack()
    public bool CanGoBack()

    // Transition
    public void LoadSceneWithTransition(string sceneName, TransitionEffect transition)

    // Additive loading
    public void LoadSceneAdditive(string sceneName)
    public void UnloadScene(string sceneName)

    // Internal
    IEnumerator LoadSceneCoroutine(string sceneName, Action onComplete)
}
```

**依存関係:**
- Singleton
- EventSystem
- StateMachine (内部で状態管理)
- TransitionEffect (オプション)

**被依存:**
- GameFlowManager

---

#### Godot (GDScript)

**ファイル:** `godot/addons/lna/core/scene_manager.gd`

```gdscript
extends Node
class_name SceneManager

# Properties
var current_scene: Node
var current_scene_path: String
var is_loading: bool = false

# Scene history
var _scene_history: Array[String] = []

# Methods
func load_scene(scene_path: String, add_to_history: bool = true) -> void
func load_scene_async(scene_path: String, on_complete: Callable = Callable()) -> void
func reload_current_scene() -> void
func go_back() -> void
func can_go_back() -> bool

# Transition
func load_scene_with_transition(scene_path: String, transition: Node) -> void

# Internal
func _deferred_goto_scene(path: String) -> void
func _load_scene_threaded(path: String, on_complete: Callable) -> void
```

**依存関係:**
- EventSystem
- StateMachine

---

#### Playdate (C)

**ファイル:** `playdate/include/lna/core/scene_manager.h`

```c
typedef struct SceneManager SceneManager;
typedef struct Scene Scene;

// Scene interface
typedef void (*SceneLoadFunc)(Scene* scene);
typedef void (*SceneUnloadFunc)(Scene* scene);
typedef void (*SceneUpdateFunc)(Scene* scene);
typedef void (*SceneDrawFunc)(Scene* scene);

struct Scene {
    const char* name;
    void* data;
    SceneLoadFunc load;
    SceneUnloadFunc unload;
    SceneUpdateFunc update;
    SceneDrawFunc draw;
};

// Scene manager
SceneManager* lna_scene_new(void);
void lna_scene_free(SceneManager* sm);

void lna_scene_register(SceneManager* sm, Scene* scene);
void lna_scene_load(SceneManager* sm, const char* scene_name);
void lna_scene_reload(SceneManager* sm);
void lna_scene_go_back(SceneManager* sm);
int lna_scene_can_go_back(SceneManager* sm);

Scene* lna_scene_get_current(SceneManager* sm);
const char* lna_scene_get_current_name(SceneManager* sm);
int lna_scene_is_loading(SceneManager* sm);

void lna_scene_update(SceneManager* sm);
void lna_scene_draw(SceneManager* sm);
```

**依存関係:**
- EventSystem
- StateMachine

---

### 2.3 GameFlowManager

#### Unity (C#)

**ファイル:** `unity/Core/GameFlowManager.cs`

```csharp
public enum GameState
{
    Boot,
    Title,
    GamePlay,
    Paused,
    GameOver,
    Result
}

public class GameFlowManager : Singleton<GameFlowManager>
{
    // State machine
    private StateMachine<IGameState> _stateMachine;

    // Properties
    public GameState CurrentState { get; private set; }
    public bool IsPaused { get; private set; }

    // Methods
    public void ChangeState(GameState newState)
    public void Pause()
    public void Resume()
    public void RestartGame()
    public void QuitToTitle()

    // State queries
    public bool IsInGamePlay()
    public bool CanPause()

    // Internal
    void Update()
    void FixedUpdate()
}
```

**State実装例:**
```csharp
public interface IGameState : IState
{
    GameState StateType { get; }
}

public class TitleState : IGameState
public class GamePlayState : IGameState
public class PausedState : IGameState
public class GameOverState : IGameState
```

**依存関係:**
- Singleton
- StateMachine
- EventSystem
- InputManager
- SceneManager

**被依存:**
- ゲームロジック全体

---

#### Godot (GDScript)

**ファイル:** `godot/addons/lna/core/game_flow_manager.gd`

```gdscript
extends Node
class_name GameFlowManager

enum GameState {
    BOOT,
    TITLE,
    GAMEPLAY,
    PAUSED,
    GAME_OVER,
    RESULT
}

# State machine
var _state_machine: StateMachine

# Properties
var current_state: GameState
var is_paused: bool = false

# Methods
func change_state(new_state: GameState) -> void
func pause() -> void
func resume() -> void
func restart_game() -> void
func quit_to_title() -> void

# State queries
func is_in_gameplay() -> bool
func can_pause() -> bool

# Internal
func _ready() -> void
func _process(delta: float) -> void
```

**State実装:**
```gdscript
# game_flow_states/title_state.gd
extends StateBase
class_name TitleState

# game_flow_states/gameplay_state.gd
extends StateBase
class_name GamePlayState

# etc...
```

**依存関係:**
- StateMachine
- EventSystem
- InputManager
- SceneManager

---

#### Playdate (C)

**ファイル:** `playdate/include/lna/core/game_flow_manager.h`

```c
typedef struct GameFlowManager GameFlowManager;

typedef enum {
    LNA_GAME_STATE_BOOT,
    LNA_GAME_STATE_TITLE,
    LNA_GAME_STATE_GAMEPLAY,
    LNA_GAME_STATE_PAUSED,
    LNA_GAME_STATE_GAME_OVER,
    LNA_GAME_STATE_RESULT
} LNAGameState;

// Lifecycle
GameFlowManager* lna_gameflow_new(void);
void lna_gameflow_free(GameFlowManager* gf);

// State management
void lna_gameflow_change_state(GameFlowManager* gf, LNAGameState new_state);
LNAGameState lna_gameflow_get_current_state(GameFlowManager* gf);

// Pause/Resume
void lna_gameflow_pause(GameFlowManager* gf);
void lna_gameflow_resume(GameFlowManager* gf);
int lna_gameflow_is_paused(GameFlowManager* gf);

// Game flow
void lna_gameflow_restart(GameFlowManager* gf);
void lna_gameflow_quit_to_title(GameFlowManager* gf);

// Queries
int lna_gameflow_is_in_gameplay(GameFlowManager* gf);
int lna_gameflow_can_pause(GameFlowManager* gf);

// Update
void lna_gameflow_update(GameFlowManager* gf);
```

**依存関係:**
- StateMachine
- EventSystem
- InputManager
- SceneManager

---

## Phase 3以降の概要

Phase 3以降（AudioManager, ResourceManager, SaveDataManager, Timer, Tween, ObjectPool, UIManager, DialogSystem, TransitionEffect）についても同様の形式で詳細設計を行いますが、まずはPhase 1, 2の実装を優先します。

---

## 依存関係グラフ

```
[Phase 1: Foundation]
├── Singleton/LNAManager (依存なし)
├── StateMachine (依存なし)
└── EventSystem (依存: Singleton)

[Phase 2: Core Managers]
├── InputManager
│   └── 依存: Singleton, EventSystem
├── SceneManager
│   └── 依存: Singleton, EventSystem, StateMachine
└── GameFlowManager
    └── 依存: Singleton, StateMachine, EventSystem, InputManager, SceneManager

[Phase 3: Media Managers]
├── AudioManager
│   └── 依存: Singleton, EventSystem
└── ResourceManager
    └── 依存: Singleton

[Phase 4: Data]
└── SaveDataManager
    └── 依存: Singleton, EventSystem

[Phase 5: Utilities]
├── Timer (依存なし)
├── Tween (依存: Timer)
└── ObjectPool (依存なし)

[Phase 6: UI]
├── UIManager
│   └── 依存: Singleton, EventSystem, Tween
├── DialogSystem
│   └── 依存: UIManager, InputManager
└── TransitionEffect
    └── 依存: Tween
```

---

## 実装チェックリスト

### Milestone 1: 基礎インフラ

#### Unity
- [ ] Singleton<T> 実装
- [ ] LNAManager 実装
- [ ] StateMachine + IState 実装
- [ ] EventSystem 実装
- [ ] GameEvents 定数定義
- [ ] ユニットテスト作成
- [ ] サンプルシーン作成

#### Godot
- [ ] SingletonBase 実装
- [ ] LNAManager (Autoload) 実装
- [ ] StateMachine + StateBase 実装
- [ ] EventSystem 実装
- [ ] GameEvents 定数定義
- [ ] テストシーン作成
- [ ] サンプルプロジェクト作成

#### Playdate
- [ ] lna_manager 実装
- [ ] state_machine 実装
- [ ] event_system 実装
- [ ] イベント定数定義
- [ ] テストコード作成
- [ ] サンプルプロジェクト作成

### Milestone 2: コアマネージャー

#### Unity
- [ ] InputManager 実装
- [ ] InputActions 定数定義
- [ ] SceneManager 実装
- [ ] GameFlowManager 実装
- [ ] GameState classes 実装
- [ ] 統合テスト作成
- [ ] デモゲーム作成（タイトル→ゲーム→結果）

#### Godot
- [ ] InputManager 実装
- [ ] InputActions 定数定義
- [ ] SceneManager 実装
- [ ] GameFlowManager 実装
- [ ] GameState nodes 実装
- [ ] 統合テスト作成
- [ ] デモゲーム作成

#### Playdate
- [ ] input_manager 実装
- [ ] scene_manager 実装
- [ ] game_flow_manager 実装
- [ ] 統合テスト作成
- [ ] デモゲーム作成

---

## 次のステップ

1. プロジェクトディレクトリ構造の作成
2. Milestone 1 の実装開始（Unity → Godot → Playdate の順）
3. 各実装後にテストとドキュメント作成
4. Milestone 1 完了後、Milestone 2 へ進む
