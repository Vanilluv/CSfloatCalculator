# CSfloatCalculator

### 一、炼金原理

首先，我们要知道CS的炼金磨损的计算符合下面的式子：

> 产物磨损 = 材料总磨损 ÷ 10 × ( 产物最大磨损值 - 产物最小磨损值 ) + 产物最小磨损值

下面以 `AK-47 | 红线` 为例，已知它的磨损范围为 `0.10~0.70`，那么，我们要炼红线，最终产物的磨损就是：

> 产物磨损 = 材料总磨损 ÷ 10 × ( 0.70 - 0.10 ) + 0.10

本质上是一个将材料总磨损平均值从0~1区间范围内映射到产物的磨损区间内的过程。

### 二、项目功能

![CSfloatCalculator流程图（Ver.20250331）](https://github.com/Vanilluv/CSfloatCalculator/blob/main/pic/CSFloatCalculator20250331.png)

本项目将整个磨损计算流程打包以便使用，若想要click-to-run，请访问[csfloatcalculator.streamlit.app/](https://csfloatcalculator.streamlit.app/)以进行使用，若你的电脑里面有<MATLAB>，可以下载后在本地使用，下面我放两张本地使用的图片。

```
使用方法：（请注意，本使用方法建立在你的电脑上面已经有MATLAB的情况下）

1、下载本项目，打开.m脚本，点击“运行”或者使用键盘上面的F5来运行
2、根据提示，输入相应的数据
3、等待结果计算完成
4、打开输出的.csv文件进行查看
```



| ![相对路径结果图](https://github.com/Vanilluv/CSfloatCalculator/blob/main/pic/1.png) | ![绝对路径结果图](https://github.com/Vanilluv/CSfloatCalculator/blob/main/pic/2.png) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|           使用相对路径，这里.txt与.m在一个目录下面           |        使用绝对路径，输出的.csv文件也会在绝对路径下面        |

### 三、特别致谢

感谢GamerNoTitle对本项目的支持，上面提到的网站是他进行实现的，访问链接：[github](https://github.com/GamerNoTitle) [个人网站](https://bili33.top)

### 四、吐槽

<div align="center">
    <img src="https://github.com/Vanilluv/CSfloatCalculator/blob/main/pic/simulation.png" width=50% align="center">
</div>

<div align = "center">尝试搞把格洛克玩玩</div>

<div align="center">
    <img src="https://github.com/Vanilluv/CSfloatCalculator/blob/main/pic/result.png" width=50% align="center">
</div>

<div align = "center">V社你是人？</div>

# 

### 五、更新日志

[20250312] 项目创建并完成

[20250331] .m脚本添加功能：必须使用的磨损（若有需要请下载20250331以后的版本），readme添加使用方法介绍
