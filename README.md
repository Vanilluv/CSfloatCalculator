# CSfloatCalculator

### 一、炼金原理

首先，我们要知道CS的炼金磨损的计算符合下面的式子：

> 产物磨损 = 材料总磨损 ÷ 10 × ( 产物最大磨损值 - 产物最小磨损值 ) + 产物最小磨损值

下面以 <AK-47 | 红线> 为例，已知它的磨损范围为 <0.10~0.70>，那么，我们要炼红线，最终产物的磨损就是：

> 产物磨损 = 材料总磨损 ÷ 10 × ( 0.70 - 0.10 ) + 0.10

本质上是一个将材料总磨损平均值从0~1区间范围内映射到产物的磨损区间内的过程。

### 二、项目功能

![CSfloatCalculator流程图](https://github.com/Vanilluv/CSfloatCalculator/blob/main/pic/CSfloatCalculator.png)

本项目将整个磨损计算流程打包以便使用，若想要click-to-run，请访问[csfloatcalculator.streamlit.app/](https://csfloatcalculator.streamlit.app/)以进行使用，若你的电脑里面有<MATLAB>，可以下载后在本地使用，下面我放两张本地使用的图片。
| ![](https://github.com/Vanilluv/CSfloatCalculator/blob/main/pic/1.png) | ![](https://github.com/Vanilluv/CSfloatCalculator/blob/main/pic/2.png) |
| :----------------------------------------------------------: | ------------------------------------------------------------ |
|           使用相对路径，这里.txt与.m在一个目录下面           | 使用绝对路径，输出的.csv文件也会在绝对路径下面               |

### 三、特别致谢

感谢GamerNoTitle对本项目的支持，上面提到的网站是他进行实现的，访问链接：[github](https://github.com/GamerNoTitle) [个人网站]([https://bili33.top](https://bili33.top/))

### 四、吐槽
<style>
table th:first-of-type {width: 30%;}
table th:nth-of-type(2) {width:70%;}
</style>
| ![尝试搞把格洛克玩玩](https://github.com/Vanilluv/CSfloatCalculator/blob/main/pic/simulation.png '尝试搞把格洛克玩玩') | ![V社你是人？](https://github.com/Vanilluv/CSfloatCalculator/blob/main/pic/result.png 'V社你是人？') |
| ------------------------------------------------------------ | :----------------------------------------------------------: |
| 尝试搞把格洛克玩玩                                           |                         V社你是人？                          |

