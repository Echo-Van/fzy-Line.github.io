---
title: Android 自带 TTS 与科大讯飞语音 SDK
tags:
  - Android
  - TTS
categories: Android
abbrlink: 4984
date: 2016-08-08 09:04:04
---

　　Text-To-Speach 简称 TTS，指能够将指定的文本转换成不同的语言音频输出的技术。通过 TTS 技术我们可以为我们的应用添加语音提醒功能，也可以做具备朗读功能的电子词典或者电子书阅读器等，总之，语音合成、语音识别等技术的应用范围还是很广的。本博客主要介绍 Android 自带的 TTS 库以及科大讯飞语音 SDK 的使用。

<!--more-->

#### Android TTS技术

　　Android 的 TTS 可以将文本随意的转换成以下任意五种语言（English、French、German、Italian和Spanish）的语音输出。很可惜，没有中文的，但是也不用担心，后面我们会介绍其他的办法。先来使用 Android 系统自带的 TTS 库，实现起来很简单，示例如下：

```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    
    mButton = (Button) findViewById(R.id.btn_speak);
    
    // 创建TTS对象
    mSpeech = new TextToSpeech(MainActivity.this, new OnInitListener() {
    
        @Override
        public void onInit(int status) {
            // TODO Auto-generated method stub
            if (status == TextToSpeech.SUCCESS) {
            mSpeech.setLanguage(Locale.ENGLISH);    //设置语言为英语
            }
        }
    });
    
    //点击按钮说话
    mButton.setOnClickListener(new OnClickListener() {
    
        @Override
        public void onClick(View v) {
            // TODO Auto-generated method stub
            mSpeech.speak("Hello World!", TextToSpeech.QUEUE_FLUSH, null);
        }
    });
}

```
　　运行程序化后点击按钮你就会听到 Hello World！，除此之外还可以设置语速、语调等参数，具体的可以参考官方文档：[http://www.android-doc.com/reference/android/speech/tts/package-summary.html](http://www.android-doc.com/reference/android/speech/tts/package-summary.html)

#### 科大讯飞语音SDK

　　Android 自带的 TTS 是不支持中文的，但是国内也有很强大的公司在做语音识别，比如众所周知的科大迅飞，它提供了免费的 SDK，很多 App 也都集成了科大讯飞的语音引擎，这里我们也来简单使用一下。

##### 下载科大讯飞Android开发SDK

　　官方地址：[http://www.xfyun.cn/](http://www.xfyun.cn/)

##### 添加jar包

　　将开发工具包中 libs 目录下的 Msc.jar 和 armeabi 复制到 Android 工程的 libs 目录。

##### 具体配置步骤

　　可查看开发工具包中doc文件夹下的 MSC Develop Manual for Android.pdf 文件，里面有详细的介绍。

（1）在工程 AndroidManifest.xml 文件中添加如下权限

　　文档中还添加了很多其他权限，本博客只介绍了 SDK 中语音合成功能的使用，如果你需要用到其他的功能那那些权限也是必须要添加的。

```xml
<!-- 连接网络权限，用于执行云端语音能力 -->
<uses-permission android:name="android.permission.INTERNET" />
<!-- 读取网络信息状态 -->
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<!-- 获取当前wifi状态 -->
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<!-- 允许程序改变网络连接状态 -->
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
<!-- 外存储读权限，构建语法需要用到此权限 -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<!-- 外存储写权限，构建语法需要用到此权限 -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    
```

（2）初始化SDK

```java
SpeechUtility.createUtility(context, SpeechConstant.APPID + "=你申请的APPID");
```

（3）语音合成基本配置（摘抄自官方文档）

　　语音合成是将文字信息转化为可听的声音信息，让机器像人一样开口说话。

```java
//1.创建 SpeechSynthesizer 对象, 第二个参数：本地合成时传 InitListener
SpeechSynthesizer mTts= SpeechSynthesizer.createSynthesizer(context, null);
//2.合成参数设置
mTts.setParameter(SpeechConstant.VOICE_NAME, "xiaoyan"); //设置发音人
mTts.setParameter(SpeechConstant.SPEED, "50");//设置语速
mTts.setParameter(SpeechConstant.VOLUME, "80");//设置音量，范围 0~100
mTts.setParameter(SpeechConstant.ENGINE_TYPE, SpeechConstant.TYPE_CLOUD); 
//设置合成音频保存位置（可自定义保存位置） ，保存在“./sdcard/iflytek.pcm”
mTts.setParameter(SpeechConstant.TTS_AUDIO_PATH, "./sdcard/iflytek.pcm");
//3.开始合成
mTts.startSpeaking("科大讯飞，让世界聆听我们的声音", mSynListener);

//合成监听器
private SynthesizerListener mSynListener = new SynthesizerListener(){
    //会话结束回调接口，没有错误时，error为null
    public void onCompleted(SpeechError error) {}
    //缓冲进度回调
    //percent为缓冲进度0~100，beginPos为缓冲音频在文本中开始位置，endPos表示缓冲音频在
    文本中结束位置，info为附加信息。
    public void onBufferProgress(int percent, int beginPos, int endPos, String info) {}
    //开始播放
    public void onSpeakBegin() {}
    //暂停播放
    public void onSpeakPaused() {}
    //播放进度回调
    //percent为播放进度0~100,beginPos为播放音频在文本中开始位置，endPos表示播放音频在文
    本中结束位置.
    public void onSpeakProgress(int percent, int beginPos, int endPos) {}
    //恢复播放回调接口
    public void onSpeakResumed() {}
    //会话事件回调接口
    public void onEvent(int arg0, int arg1, int arg2, Bundle arg3) {}
};

```

#### 简单的Demo

　　博主使用科大讯飞 SDK 的语音合成功能制作了一个简单的 Demo，它可以选择不同的发音人来发音，并且可以调节语速和音量。

![8-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/8/8-1.png)

　　以下是 MainActivity.java 的部分代码：

```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    //初始化SDK
    SpeechUtility.createUtility(this, SpeechConstant.APPID + "=571771fd");
    
    mEditText = (EditText) findViewById(R.id.et_speak);
    mButton = (Button) findViewById(R.id.btn_speak);
    mSeekBarVolume = (SeekBar) findViewById(R.id.sb_speak_volume);
    mSeekBarSpeed = (SeekBar) findViewById(R.id.sb_speak_speed);
    mSpinner = (Spinner) findViewById(R.id.spinner);
    
    // 创建 SpeechSynthesizer 对象, 第二个参数：本地合成时传 InitListener
    mTts = SpeechSynthesizer.createSynthesizer(this, null);
    // 合成参数设置
    mTts.setParameter(SpeechConstant.VOICE_NAME, "xiaoyan"); // 设置发音人
    mTts.setParameter(SpeechConstant.SPEED, "50");// 设置语速
    mTts.setParameter(SpeechConstant.VOLUME, "80");// 设置音量，范围 0~100
    mTts.setParameter(SpeechConstant.ENGINE_TYPE, SpeechConstant.TYPE_CLOUD);     // 设置云端

    // 设置合成音频保存位置（可自定义保存位置） ，保存在“./sdcard/iflytek.pcm”
    mTts.setParameter(SpeechConstant.TTS_AUDIO_PATH, "./sdcard/iflytek.wav");
    
    mSeekBarSpeed.setProgress(50);
    mSeekBarVolume.setProgress(80);
    
    mSpinner.setOnItemSelectedListener(new OnItemSelectedListener() {
    
        @Override
        public void onItemSelected(AdapterView<?> arg0, View arg1,int position, long arg3) {
            // TODO Auto-generated method stub
            // 设置发音人
            mTts.setParameter(SpeechConstant.VOICE_NAME, str[position]); 
        }
        
        @Override
        public void onNothingSelected(AdapterView<?> arg0) {
        // TODO Auto-generated method stub
        
        }
    });
        
    mSeekBarSpeed.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
    
        @Override
        public void onStopTrackingTouch(SeekBar seekbar) {
            // TODO Auto-generated method stub
            // 设置语速
            mTts.setParameter(SpeechConstant.SPEED, seekbar.getProgress()+ "");
        }
        
        @Override
        public void onStartTrackingTouch(SeekBar arg0) {
            // TODO Auto-generated method stub
        
        }
        
        @Override
        public void onProgressChanged(SeekBar arg0, int arg1, boolean arg2) {
            // TODO Auto-generated method stub
        
        }
    });

    mSeekBarVolume.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
    
        @Override
        public void onStopTrackingTouch(SeekBar seekbar) {
            // TODO Auto-generated method stub
            // 设置音量，范围 0~100
            mTts.setParameter(SpeechConstant.VOLUME,seekbar.getProgress() + "");
        }
        
        @Override
        public void onStartTrackingTouch(SeekBar arg0) {
            // TODO Auto-generated method stub
        
        }
        
        @Override
        public void onProgressChanged(SeekBar arg0, int arg1,
        boolean arg2) {
            // TODO Auto-generated method stub
        
        }
    });
    
    mButton.setOnClickListener(new OnClickListener() {
    
        @Override
        public void onClick(View arg0) {
            // TODO Auto-generated method stub
            String text = mEditText.getText().toString();
            // 开始合成
            mTts.startSpeaking(text, mSynListener);
        }
    });
}    
```

　　至此，我们就可以为我们的应用添加语音合成功能啦，是不是很方便？其实，除此之外，科大讯飞的 SDK 还具备语音识别、声纹密码、人脸识别等多种功能，具体的操作方法请参考下载的 SDK 工具包中的中文文档资料。



