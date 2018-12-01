---
title: Android 聊天机器人之图灵机器人
tags:
  - Android
categories: Android
abbrlink: 12091
date: 2016-09-22 10:07:29
---

　　图灵机器人—-中文语境下智能度最高的机器人大脑。之前写了一个有意思的小 Demo，其实也比较简单，只是使用了图灵机器人的 SDK 来做了一个简单的聊天机器人，不过图灵机器人确实比较智能，而且功能十分丰富，它不仅提供了数据访问接口，还集成了 SDK 供大家使用，所以很方便很实用。如果无聊了，就自己动手来做一个聊天机器人解解闷吧！

<!--more-->

##### 下载Android版本SDK

　　图灵机器人官网：[http://www.tuling123.com/](http://www.tuling123.com/) 。注册之后创建机器人，就可以得到APIKEY和密钥，然后下载SDK，如下图：

![22-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/9/22-1.png)

##### 将SDK添加到工程中

　　将SDK压缩包中的libs文件夹复制到工程目录替换掉原来的libs。

##### 添加权限

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
```

##### SDK初始化

```java
SDKInitBuilder builder = new SDKInitBuilder(this)
                .setSecret(TURING_SECRET).setTuringKey(TURING_APIKEY)
                .setUniqueId(UNIQUEID);
SDKInit.init(builder, new InitListener() {

    @Override
    public void onFail(String arg0) {
        // TODO Auto-generated method stub
    
    }
    
    @Override
    public void onComplete() {
        // TODO Auto-generated method stub
        mTuringApiManager = new TuringApiManager(MainActivity.this);
        mTuringApiManager.setHttpListener(myHttpConnectionListener);
        // ttsManager.startTTS("你好啊");              
    }
});
```


##### 聊天机器人Demo

　　实现的效果如下：

![22-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/9/22-2.png)

　　实现步骤：

##### 定义消息实体类

```java
public class ChatMessage {
    private String name;    //消息的名字
    private String msg;     //消息的内容
    private Type type;      //消息的类型
    private Date date;      //消息的时间
    
    //消息类型：发送、接收
    public enum Type {
        INCOMING, OUTCOMING
    }
    
    public ChatMessage() {
        // TODO Auto-generated constructor stub
    }
    
    public ChatMessage(String msg,Type type,Date date) {
        // TODO Auto-generated constructor stub
        setMsg(msg);
        setType(type);
        setDate(date);
    }
    
    //生成各成员属性的set和get方法
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getMsg() {
        return msg;
    }
    
    public void setMsg(String msg) {
        this.msg = msg;
    }
    
    public Type getType() {
        return type;
    }
    
    public void setType(Type type) {
        this.type = type;
    }
    
    public Date getDate() {
        return date;
    }
    
    public void setDate(Date date) {
        this.date = date;
    }
}
```

##### 编写适配器类

　　使用适配器将数据与视图绑定起来。

```java
public class ChatMessageAdapter extends BaseAdapter {

    private List<ChatMessage> mDatas;
    private Context mContext;
    
    //使用ViewHolder临时存储view，提高效率
    private final class ViewHolder {
        TextView mDate;
        TextView mMsg;
    }
    
    public ChatMessageAdapter(Context context, List<ChatMessage> data) {
        // TODO Auto-generated constructor stub
        mDatas = data;
        mContext = context;
    }
    
    @Override
    public int getCount() {
        // TODO Auto-generated method stub
        return mDatas.size();
    }
    
    @Override
    public Object getItem(int position) {
        // TODO Auto-generated method stub
        return mDatas.get(position);
    }
    
    @Override
    public long getItemId(int position) {
        // TODO Auto-generated method stub
        return position;
    }
    
    //得到布局的类型
    @Override
    public int getItemViewType(int position) {
        ChatMessage chatMessage = mDatas.get(position);
        if (chatMessage.getType() == Type.INCOMING) {
            return 0;
        }
        return 1;
    }
    
    @Override
    public int getViewTypeCount() {
        return 2;
    }
    
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub
        ViewHolder viewHolder = null;
        if (convertView == null) {
            //更具不同的布局，加载不同的控件
            if (getItemViewType(position) == 0) {
                convertView = LayoutInflater.from(mContext).inflate(
                        R.layout.item_from_msg, null);
                viewHolder = new ViewHolder();
                viewHolder.mDate = (TextView) convertView
                        .findViewById(R.id.id_form_msg_date);
                viewHolder.mMsg = (TextView) convertView
                        .findViewById(R.id.id_from_msg_info);
            } else {
                convertView = LayoutInflater.from(mContext).inflate(
                        R.layout.item_to_msg, null);
                viewHolder = new ViewHolder();
                viewHolder.mDate = (TextView) convertView
                        .findViewById(R.id.id_to_msg_date);
                viewHolder.mMsg = (TextView) convertView
                        .findViewById(R.id.id_to_msg_info);
            }
            convertView.setTag(viewHolder);     //使用setTag把view缓存起来
        } else {
            viewHolder = (ViewHolder) convertView.getTag();     //使用getTag得到view
        }
        ChatMessage chatMessage = mDatas.get(position);
        // 设置数据
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        viewHolder.mDate.setText(df.format(chatMessage.getDate()));
        viewHolder.mMsg.setText(chatMessage.getMsg());
        return convertView;
    }
}
```

##### 实现业务逻辑

```java
public class MainActivity extends Activity {

    /**
     * 申请的turing的apikey
     * **/
    private final String TURING_APIKEY = "56433fe6f67942ff80c4d7bd2d20fe34";
    /**
     * 申请的secret
     * **/
    private final String TURING_SECRET = "d9989eac6e4cab39";
    private final String UNIQUEID = "131313131";
    private TuringApiManager mTuringApiManager;
    private ListView mMsgs;
    private ChatMessageAdapter mAdapter;
    private List<ChatMessage> mDatas;
    
    private EditText mInputMsg;
    private Button mSendMsg;

    //设置监听
    HttpConnectionListener myHttpConnectionListener = new HttpConnectionListener() {

    @Override
    public void onSuccess(RequestResult result) {
        // TODO Auto-generated method stub
        if (result != null) {
            String res = result.getContent().toString();    //获取服务器返回数据
            System.out.println(res);
            JSONObject jo;
            try {
                jo = new JSONObject(res);   //解析JSON格式数据
                String text = jo.getString("text");
                mDatas.add(new ChatMessage(text, Type.INCOMING, new Date())); 
                mAdapter.notifyDataSetChanged();    //更新UI
                mMsgs.setSelection(mDatas.size()-1);
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }   
        }
    }
    
    @Override
    public void onError(ErrorMessage arg0) {
    // TODO Auto-generated method stub
    
    }
    };
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_main);
        
        //SDK初始化
        SDKInitBuilder builder = new SDKInitBuilder(this)
                    .setSecret(TURING_SECRET).setTuringKey(TURING_APIKEY)
                    .setUniqueId(UNIQUEID);
        
        SDKInit.init(builder, new InitListener() {
        
            @Override
            public void onFail(String arg0) {
                // TODO Auto-generated method stub
            
            }
            
            @Override
            public void onComplete() {
                // TODO Auto-generated method stub
                mTuringApiManager = new TuringApiManager(MainActivity.this);
                mTuringApiManager.setHttpListener(myHttpConnectionListener);
            }
        });
        
        initView();     //初始化视图
        initDatas();    //初始化数据
        
        //发送消息按钮的监听事件
        mSendMsg.setOnClickListener(new OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                final String toMsg = mInputMsg.getText().toString();
                if (TextUtils.isEmpty(toMsg))
                {
                    Toast.makeText(MainActivity.this,"发送消息不能为空！",Toast.LENGTH_SHORT).show();
                    return;
                }
            
                //得到输入框的内容，转化成一个消息对象
                ChatMessage toMessage = new ChatMessage(toMsg,Type.OUTCOMING,new Date());
                mDatas.add(toMessage);
                mAdapter.notifyDataSetChanged();
                mMsgs.setSelection(mDatas.size()-1);
                
                //清空输入框
                mInputMsg.setText("");
                
                //发送消息到图灵服务器
                mTuringApiManager.requestTuringAPI(toMsg);
            
            }
        });
    }
    
    //初始化数据
    private void initDatas()
    {
        mDatas = new ArrayList<ChatMessage>();
        mDatas.add(new ChatMessage("你好，小农为您服务", Type.INCOMING, new Date()));
        mAdapter = new ChatMessageAdapter(this, mDatas);
        mMsgs.setAdapter(mAdapter);
    }
    
    //初始化视图
    private void initView()
    {
        mMsgs = (ListView) findViewById(R.id.id_listview_msgs);
        mInputMsg = (EditText) findViewById(R.id.id_input_msg);
        mSendMsg = (Button) findViewById(R.id.id_send_msg);
    }
}
```

