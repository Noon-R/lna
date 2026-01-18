# LNA for Playdate

Playdate向けのLNAライブラリ実装です（C言語）。

## インストール

1. `playdate`フォルダの内容をPlaydateプロジェクトにコピー
2. Makefileに以下を追加：

```makefile
# LNA Library
LNA_SRC = lna/src/core/*.c lna/src/utilities/*.c lna/src/ui/*.c
INCLUDES += -Ilna/include

# Add to your source files
SRC += $(LNA_SRC)
```

## 使用方法

### 基本セットアップ

```c
#include "pd_api.h"
#include "lna/core/lna_manager.h"

static PlaydateAPI* pd = NULL;

int eventHandler(PlaydateAPI* playdate, PDSystemEvent event, uint32_t arg)
{
    if (event == kEventInit)
    {
        pd = playdate;

        // Initialize LNA
        lna_manager_init(pd);

        // Register input actions
        lna_input_register_action(lna_get_input(), "jump", LNA_BUTTON_A);

        // Subscribe to events
        lna_events_subscribe(lna_get_events(), LNA_EVENT_SCENE_LOAD_COMPLETE, on_scene_loaded);

        // Set update callback
        pd->system->setUpdateCallback(update, pd);
    }

    return 0;
}

static int update(void* userdata)
{
    PlaydateAPI* pd = (PlaydateAPI*)userdata;

    // Update LNA systems
    lna_manager_update();

    // Your game logic
    if (lna_input_get_action_down(lna_get_input(), "jump"))
    {
        pd->system->logToConsole("Jump!");
    }

    return 1;
}

static void on_scene_loaded(void* data)
{
    pd->system->logToConsole("Scene loaded!");
}
```

### シーン管理

```c
// Register scenes
Scene title_scene = {
    .name = "title",
    .load = title_load,
    .unload = title_unload,
    .update = title_update,
    .draw = title_draw
};

lna_scene_register(lna_get_scene(), &title_scene);

// Load scene
lna_scene_load(lna_get_scene(), "title");
```

### ゲームフロー管理

```c
// Change game state
lna_gameflow_change_state(lna_get_gameflow(), LNA_GAME_STATE_GAMEPLAY);

// Pause/Resume
lna_gameflow_pause(lna_get_gameflow());
lna_gameflow_resume(lna_get_gameflow());
```

## メモリ管理

Playdateはメモリが限られているため、以下の点に注意してください：

- ObjectPoolを積極的に使用
- 不要なリソースはすぐに解放
- 大きなバッファの動的確保は避ける

## 実装状況

- [ ] lna_manager
- [ ] state_machine
- [ ] event_system
- [ ] input_manager
- [ ] scene_manager
- [ ] game_flow_manager
- [ ] audio_manager
- [ ] savedata_manager
- [ ] resource_manager
- [ ] timer
- [ ] tween
- [ ] object_pool
- [ ] ui_manager
- [ ] dialog_system
- [ ] transition_effect

## 詳細ドキュメント

各機能の詳細は[docs/playdate](../docs/playdate/)を参照してください。
