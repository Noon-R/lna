# LNA for Unity

Unity向けのLNAライブラリ実装です。

## インストール

1. `unity`フォルダをUnityプロジェクトの`Assets`フォルダにコピー
2. Unity Editorで自動的にコンパイルされます

## 使用方法

### 基本セットアップ

シーンに空のGameObjectを作成し、`LNAManager`スクリプトをアタッチしてください。

```csharp
// 各マネージャーへのアクセス
LNAManager.Input.GetActionDown("jump");
LNAManager.Audio.PlayBGM("title_theme");
LNAManager.Scene.LoadScene("GameScene");
```

### 最小限の例

```csharp
using UnityEngine;
using LNA;

public class GameController : MonoBehaviour
{
    void Start()
    {
        // Input action registration
        LNAManager.Input.RegisterAction(InputActions.JUMP, KeyCode.Space);

        // Event subscription
        LNAManager.Events.Subscribe(GameEvents.SCENE_LOAD_COMPLETE, OnSceneLoaded);
    }

    void Update()
    {
        if (LNAManager.Input.GetActionDown(InputActions.JUMP))
        {
            Debug.Log("Jump!");
        }
    }

    void OnSceneLoaded()
    {
        Debug.Log("Scene loaded!");
    }
}
```

## 実装状況

- [ ] Singleton / LNAManager
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

各機能の詳細は[docs/unity](../docs/unity/)を参照してください。
