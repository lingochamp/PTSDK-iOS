## iOS 版 PTSDK 介绍

### 说明

PTSDK 为流利说提供给第三方的服务。该 Repo 用于提供 iOS 版本 PTSDK 各版本 Framework 的下载，更新和文档说明。

### 当前稳定版本
1.0

### 安装

#### 手动集成
1. 把 PTSDK.framework 加入项目中 (当前稳定版本下载地址为: [Chun 待补充](Chun 待补充))
2. 在项目的 target settings 中的 "General" tab，点击 "Embedded Binaries" 下方加号，添加 "PTSDK.framework"
3. 检查 Build Settings 里面 Framework Search Paths 路径设置是否正确

#### Carthage or CocoaPods

1. 可以通过打包对应 PTSDK 版本的编译文件为 Zip 格式放到自己 Server 的文件服务器上，使用 Carthage `binary` 进行集成。具体可以参考：[https://github.com/Carthage/Carthage](https://github.com/Carthage/Carthage)
2. 可以构建私有 CocoaPods 源，使用 CocoaPods 安装。

### 最小支持 iOS 版本

iOS PTSDK 最小支持的 iOS 版本为： iOS 8.0


### 系统权限要求和 Xcode 配置

1. PTSDK 在使用前需要获取到用户 iOS 的录音权限。请务必在 Xcode Project 中 Info 下面添加 `Privacy - Microphone Usage Description` 对应的描述。
2. PTSDK 需要获取到用户的网络权限。
3. PTSDK 需要使用语音播放服务，请务必在 `Xcode Project - Capabilities - Background Modes` 下勾选 `Audio, AirPlay, and Picture in Picture`。

### 使用

通过调用 `PT.h` 下面的

	+ (void)startWithUserIdentifier:(nonnull NSString *)userIdentifier
                  tokenProvider:(nonnull id <PTTokenProviding>)provider
      fromNavigationController:(nonnull UINavigationController *)navigationController
             completionHandler:(nullable PTCompletionHandler)completionHandler
             
方法开始 PT 流程，其中需要注意点如下：

1. userIdentifier 用于标识用户，同一个用户则会继续上一次的进度继续测试。
2. tokenProvider 用于 PT 过程中的校验服务，由开发者实现。
2. navigationController 用于在传入的 navigationController 上 push PT 页面。
3. completionHandler 用于获取 PT 完成后的结果。

#### 关于 tokenProvider

`tokenProvider`需要遵从 `PTTokenProviding` 协议。`PTTokenProviding` 定义了获取 Token 的行为。其中 PTTokenProviding 定义如下： 

	- (void)fetchTokenWithCompletionHandler:(nonnull void (^)(NSString * _Nullable token, NSError * _Nullable error))completionHandler;
	- (void)invalidToken:(nonnull NSString *)token;


1. PTSDK 内部会持有外部传入的`tokenProvider`对象。
2. `fetchTokenWithCompletionHandler` 接口用于 PTSDK 拉取最新有效的 Token。 
3. `invalidToken` 接口用于 PTSDK 告诉实现方当前 cache 的 Token 已经失效。 
4. 第三发开发者应该从自己的 Backend API 获取到用于 PTSDK 的 Token。（关于 PTSDK 流利说提供的获取 Token 服务文档地址如下：[Chun 待补充](Chun 待补充)）
5. 具体 TokenProvider 的实现可参考 demo。


#### 处理 PT 结果 PTCompletionHandler

1. 在 PT 测试成功的情况下，PTCompletionHandler 的第一个`responseObject`将会返回对应的测试结果，大致数据格式如下：
	

		 {
		   fluency = Poor;
		   fluencyAsPercentage = 0;
		   level = 4;
		   levelDescription = "\U4e2d\U4f4e\U7ea7";
		   levelName = 4;
		   message = ok;
		   nextActionName = "";
		   nextActionUrl = "";
		   pronunciation = Poor;
		   pronunciationAsPercentage = 0;
		   score = 97;
		   summary = "";
		 }

2. 在 PT 流程出错的情况下，PTCompletionHandler 的第二个参数`error`将会返回对应的错误信息。
3. 当用户执行为 PT 流程之后，PTSDK 内部会在调用完`completionHandler`后紧接着使用传入的`navigationController`执行`popViewControllerAnimated`的操作。

#### 注意

1. PTSDK 开始之前需要获取用户的录音权限，只有当 `[AVAudioSession sharedInstance].recordPermission == AVAudioSessionRecordPermissionGranted` 时才能进入 PTSDK。
2. PTSDK 内部会把 AudioSessionCategory 设置为 `AVAudioSessionCategoryPlayAndRecord`。

### Framework 问题反馈
在开始集成 PTSDK 时，可以通过调用 `PT.h` 下面的

	+ (void)setDebugMode:(BOOL)enabled;

把 PTSDK 的日志打开。

如果出现了问题，可以通过调用

	+ (void)exportDebugLog:(void (^_Nonnull) (NSError *_Nullable error, NSURL *_Nullable logURL))completion;

获取到 PTSDK 的详细日志文件，可以把该日志文件递交给流利说的开发者，用于定位问题。

这里需要注意：

1. `exportDebugLog` 的 Block 回调是在后台线程。
2. 不应该在上线的时候打开 DebugMode。