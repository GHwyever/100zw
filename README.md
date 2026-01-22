# 100句旅游中文 (Chinese Travel 100)

这款App专为中国旅游设计，覆盖交通、餐饮、购物等高频场景，提供“听、说、用”三步学习法。

基于 **Flutter** 开发，一套代码支持 **iOS、Android 和 Web**。

## 🚀 快速开始 (Setup Guide)

由于这是一个生成的源码包，你需要先初始化 Flutter 环境。

### 1. 初始化项目结构
在项目根目录（包含 `pubspec.yaml` 的文件夹）运行以下命令，生成 iOS/Android/Web 的原生工程文件：

```bash
flutter create .
```

### 2. 安装依赖
```bash
flutter pub get
```

### 3. 配置权限 (Permissions)

为了使用语音识别 (Speech to Text) 和 朗读 (TTS) 功能，需要添加权限。

#### 📱 iOS (`ios/Runner/Info.plist`)
打开 `ios/Runner/Info.plist`，在 `<dict>` 标签内添加：
```xml
<key>NSSpeechRecognitionUsageDescription</key>
<string>App需要使用语音识别功能来评估您的发音。</string>
<key>NSMicrophoneUsageDescription</key>
<string>App需要访问麦克风以进行跟读练习。</string>
```

#### 🤖 Android (`android/app/src/main/AndroidManifest.xml`)
打开 `android/app/src/main/AndroidManifest.xml`，在 `<manifest>` 标签内添加：
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<queries>
    <intent>
        <action android:name="android.intent.action.TTS_SERVICE" />
    </intent>
</queries>
```

### 4. 运行项目
```bash
flutter run
```

## 🛠️ 技术栈
- **Framework**: Flutter (Dart)
- **Navigation**: go_router
- **State**: Provider / Local State
- **Audio**: flutter_tts (语音合成), speech_to_text (语音识别)
- **Storage**: shared_preferences (本地存储)

## 📂 目录结构
- `lib/data`: 核心数据（100句语料）
- `lib/screens`:
  - `home_screen.dart`: 首页分类
  - `learning_screen.dart`: 核心学习页 (听/说/用)
  - `emergency_screen.dart`: 紧急求助大卡片
