---
title: Android Spinner 控件之省市区（县）三级联动
tags:
  - Android
  - Spinner
categories: Android
abbrlink: 2561
date: 2016-07-01 22:11:05
---

　　使用 Spinner 控件实现省市区三级联动在很多地方都需要用到，比如用户个人信息填写、快递地址填写等场景，这是一个比较基本的功能，但是实现起来却有点麻烦，因为要加载很多的资源数组。掌握基本的省市区三级联动很有必要，当然，再加上一些酷炫的 UI 设计就能更 nice。

<!--more-->

#### 布局文件

　　添加三个 Spinner 控件，分别用于省、市、区（县）：

```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="horizontal" >

    <Spinner
        android:id="@+id/spinner_province"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginTop="10dp"
        android:layout_weight="1.2" >
    </Spinner>

    <Spinner
        android:id="@+id/spinner_city"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginLeft="4dp"
        android:layout_marginTop="10dp"
        android:layout_weight="1.2" >
    </Spinner>

    <Spinner
        android:id="@+id/spinner_county"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginLeft="4dp"
        android:layout_marginTop="10dp"
        android:layout_weight="1.8" >
    </Spinner>

</LinearLayout>

```

#### 逻辑实现

　　实现原理：为每一个 Spinner 添加监听，选择省份后加载该省份的市区（县）数组资源，选择市之后加载该市对应的区（县）数组资源，从而实现三级联动。

　　代码有点多，这里只贴了核心代码，资源数组与定义的资源数组ID数组都没有写出来了，目前博客的下载插件还没弄好，暂时无法提供下载，，如果需要源码可以联系我联系方式在主页可看到。

```java
public class MainActivity extends Activity {

    private Spinner mProvinceSpinner, mCitySpinner, mCountySpinner;
    private ArrayAdapter<CharSequence> mProvinceAdapter, mCityAdpater,
            mCountyAdapter;
    private int mProvinceId, mCityId;
    private String mProvinceName, mCityName, mCountyName;
    
        @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mProvinceSpinner = (Spinner) findViewById(R.id.spinner_province);
        mCitySpinner = (Spinner) findViewById(R.id.spinner_city);
        mCountySpinner = (Spinner) findViewById(R.id.spinner_county);

        // 省份选择
        mProvinceAdapter = ArrayAdapter.createFromResource(this,
                R.array.province_item, android.R.layout.simple_spinner_item);
        mProvinceAdapter
                .setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mProvinceSpinner.setAdapter(mProvinceAdapter);

        mProvinceSpinner
                .setOnItemSelectedListener(new OnItemSelectedListener() {

                    @Override
                    public void onItemSelected(AdapterView<?> arg0, View arg1,
                            int arg2, long arg3) {
                        // TODO Auto-generated method stub
                        // 获取省的ID
                        mProvinceId = mProvinceSpinner
                                .getSelectedItemPosition();
                        // 获取省的名字
                        mProvinceName = mProvinceSpinner.getSelectedItem()
                                .toString();
                        // 市选择
                        SpinnerBindResource(mCitySpinner, mCityAdpater,
                                city[mProvinceId]);
                        mCitySpinner
                                .setOnItemSelectedListener(new OnItemSelectedListener() {

                                    @Override
                                    public void onItemSelected(
                                            AdapterView<?> arg0, View arg1,
                                            int arg2, long arg3) {
                                        // TODO Auto-generated method stub
                                        // 获取市的ID
                                        mCityId = mCitySpinner
                                                .getSelectedItemPosition();
                                        // 获取市的名字
                                        mCityName = mCitySpinner
                                                .getSelectedItem().toString();
                                        // 县选择
                                        switch (mProvinceId) {
                                        case 0:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfBeiJing[mCityId]);
                                            break;
                                        case 1:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfTianJing[mCityId]);
                                            break;
                                        case 2:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfHeBei[mCityId]);
                                            break;
                                        case 3:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfShanXi1[mCityId]);
                                            break;
                                        case 4:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfNeiMengGu[mCityId]);
                                            break;
                                        case 5:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfLiaoNing[mCityId]);
                                            break;
                                        case 6:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfJiLin[mCityId]);
                                            break;
                                        case 7:
                                            SpinnerBindResource(
                                                    mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfHeiLongJiang[mCityId]);
                                            break;
                                        case 8:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfShangHai[mCityId]);
                                            break;
                                        case 9:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfJiangSu[mCityId]);
                                            break;
                                        case 10:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfZheJiang[mCityId]);
                                            break;
                                        case 11:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfAnHui[mCityId]);
                                            break;
                                        case 12:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfFuJian[mCityId]);
                                            break;
                                        case 13:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfJiangXi[mCityId]);
                                            break;
                                        case 14:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfShanDong[mCityId]);
                                            break;
                                        case 15:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfHeNan[mCityId]);
                                            break;
                                        case 16:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfHuBei[mCityId]);
                                            break;
                                        case 17:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfHuNan[mCityId]);
                                            break;
                                        case 18:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfGuangDong[mCityId]);
                                            break;
                                        case 19:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfGuangXi[mCityId]);
                                            break;
                                        case 20:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfHaiNan[mCityId]);
                                            break;
                                        case 21:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfChongQing[mCityId]);
                                            break;
                                        case 22:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfSiChuan[mCityId]);
                                            break;
                                        case 23:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfGuiZhou[mCityId]);
                                            break;
                                        case 24:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfYunNan[mCityId]);
                                            break;
                                        case 25:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfXiZang[mCityId]);
                                            break;
                                        case 26:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfShanXi2[mCityId]);
                                            break;
                                        case 27:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfGanSu[mCityId]);
                                            break;
                                        case 28:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfQingHai[mCityId]);
                                            break;
                                        case 29:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfNingXia[mCityId]);
                                            break;
                                        case 30:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfXinJiang[mCityId]);
                                            break;
                                        case 31:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfHongKong[mCityId]);
                                            break;
                                        case 32:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfAoMen[mCityId]);
                                            break;
                                        case 33:
                                            SpinnerBindResource(mCountySpinner,
                                                    mCountyAdapter,
                                                    countyOfTaiWan[mCityId]);
                                            break;

                                        default:
                                            break;
                                        }

                                        mCountySpinner
                                                .setOnItemSelectedListener(new OnItemSelectedListener() {

                                                    @Override
                                                    public void onItemSelected(
                                                            AdapterView<?> arg0,
                                                            View arg1,
                                                            int arg2, long arg3) {
                                                        // TODO Auto-generated
                                                        // method stub
                                                        mCountyName = mCountySpinner
                                                                .getSelectedItem()
                                                                .toString();
                                                        Toast.makeText(
                                                                MainActivity.this,
                                                                "你选择的是："
                                                                        + mProvinceName
                                                                        + "-"
                                                                        + mCityName
                                                                        + "-"
                                                                        + mCountyName,
                                                                Toast.LENGTH_SHORT)
                                                                .show();
                                                    }

                                                    @Override
                                                    public void onNothingSelected(
                                                            AdapterView<?> arg0) {
                                                        // TODO Auto-generated
                                                        // method stub

                                                    }
                                                });
                                    }

                                    @Override
                                    public void onNothingSelected(
                                            AdapterView<?> arg0) {
                                        // TODO Auto-generated method stub

                                    }
                                });
                    }

                    @Override
                    public void onNothingSelected(AdapterView<?> arg0) {
                        // TODO Auto-generated method stub

                    }
                });
    }

    // 数据绑定
    public void SpinnerBindResource(Spinner spinner,
            ArrayAdapter<CharSequence> adapter, int arrayId) {
        adapter = ArrayAdapter.createFromResource(this, arrayId,
                android.R.layout.simple_spinner_item);

        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);
    }
}
```

#### 效果展示

![1-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/7/1-1.jpg)![1-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/7/1-2.jpg)

　　注：如果需要源码可以联系我，联系方式在主页可看到。
