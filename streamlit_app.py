import streamlit as st
import itertools
import pandas as pd
import math
from io import StringIO, BytesIO
from decimal import Decimal, getcontext

# 设置高精度计算环境
getcontext().prec = 34  # 34位有效数字精度

st.set_page_config(
    page_title="CounterStrike 2 炼金磨损计算器", 
    page_icon="🔫", 
    layout="centered"
)

st.title("CounterStrike 2 炼金磨损计算器")
st.write(
    """
### 使用说明
1. 上传包含磨损值的文件（每行一个0-1之间的数值）或手动输入数据
2. 设置理论最小/最大值（默认0-1）
3. 设置目标最小/最大值
4. 点击计算后，会列出所有符合条件的材料组合
5. 结果可导出为XLSX

### 免责声明
- 本工具仅供学习和研究使用。
- 炼金易上头，操作需谨慎！
- 最后祝大家都能够出货！

[CSfloatCalculator](https://github.com/Vanilluv/CSfloatCalculator)

---
"""
)

# 数据输入部分
st.header("材料数据输入")
input_method = st.radio("选择数据输入方式", ["手动输入", "文件上传"])

materials = []
if input_method == "文件上传":
    uploaded_file = st.file_uploader("上传数据文件（.txt或.csv）", type=["txt", "csv"])
    if uploaded_file:
        stringio = StringIO(uploaded_file.getvalue().decode("utf-8"))
        content = stringio.read()
        lines = content.splitlines()
        for line in lines:
            stripped = line.strip()
            if stripped:
                try:
                    # 直接转换为Decimal
                    value = Decimal(stripped)
                    if 0 <= value <= 1:
                        materials.append(value)
                    else:
                        st.error(f"数值超出范围: {stripped}")
                        break
                except:
                    st.error(f"无效数据: {stripped}")
                    break
else:
    manual_input = st.text_area("手动输入数据（每行一个0-1之间的数值）", height=200)
    if manual_input:
        lines = manual_input.split("\n")
        for i, line in enumerate(lines):
            stripped = line.strip()
            if stripped:
                try:
                    value = Decimal(stripped)
                    if 0 <= value <= 1:
                        materials.append(value)
                    else:
                        st.error(f"第{i+1}行数值超出范围: {stripped}")
                        break
                except:
                    st.error(f"第{i+1}行无效数据: {stripped}")
                    break

if len(materials) < 10:
    st.error("需要至少10个有效材料数据！")

# 参数设置部分
st.header("参数设置")
col1, col2 = st.columns(2)

with col1:
    st.subheader("理论范围")
    theory_min = Decimal(str(st.number_input(
        "理论最小值", 0.0, 1.0, 0.0, step=0.0000000000000001, format="%.17f"
    )))
with col2:
    st.subheader("")  # 保持对齐
    theory_max = Decimal(str(st.number_input(
        "理论最大值", 0.0, 1.0, 1.0, step=0.0000000000000001, format="%.17f"
    )))

# 范围模式选择
range_mode = st.radio("选择范围模式", ["直接指定范围", "中间值浮动范围"], index=0)

# 目标范围处理
target_min = Decimal('0')
target_max = Decimal('0')
if range_mode == "直接指定范围":
    col3, col4 = st.columns(2)
    with col3:
        target_min = Decimal(str(st.number_input(
            "目标最小值", 0.0, 1.0, 0.0, step=0.0000000000000001, format="%.17f"
        )))
    with col4:
        target_max = Decimal(str(st.number_input(
            "目标最大值", 0.0, 1.0, 1.0, step=0.0000000000000001, format="%.17f"
        )))
else:
    col5, col6 = st.columns(2)
    with col5:
        center_value = Decimal(str(st.number_input(
            "中间值", 0.0, 1.0, 0.5, step=0.0000000000000001, format="%.17f"
        )))
    with col6:
        delta = Decimal(str(st.number_input(
            "浮动范围 (±)", 0.0, 1.0, 0.0001, step=0.0000000000000001, format="%.17f"
        )))
    
    # 计算实际范围
    target_min = max(Decimal('0'), center_value - delta)
    target_max = min(Decimal('1'), center_value + delta)
    st.info(f"实际范围：{target_min:.17f} ~ {target_max:.17f}")

# 参数验证
if theory_min >= theory_max:
    st.error("理论最小值必须小于理论最大值！")
    st.stop()

if target_min >= target_max:
    st.error("有效目标范围不合法！")
    st.stop()

if st.button("开始计算"):
    total_combinations = math.comb(len(materials), 10)
    if total_combinations > 10**6:
        st.warning(f"警告：需要计算 {total_combinations:,} 种组合，可能需要较长时间！")

    results = []
    progress_bar = st.progress(0)
    status_text = st.empty()

    calculated = 0
    for combo in itertools.combinations(materials, 10):
        # 高精度计算
        avg = sum(combo) / Decimal('10')
        mapped_value = avg * (theory_max - theory_min) + theory_min
        
        if target_min <= mapped_value <= target_max:
            # 保持17位小数格式
            formatted_combo = [f"{x:.17f}" for x in combo]
            results.append(formatted_combo + [f"{mapped_value:.17f}"])

        # 进度更新
        calculated += 1
        if calculated % 1000 == 0:
            progress = calculated / total_combinations
            progress_bar.progress(progress)
            status_text.text(f"进度：{calculated}/{total_combinations} ({progress:.2%})")

    progress_bar.progress(1.0)
    status_text.text("计算完成！下面只显示前1000条结果，如果需要完成结果可以导出 Excel 文件后查看")

    if results:
        st.subheader(f"找到 {len(results)} 个符合条件的组合")
        df = pd.DataFrame(
            results, 
            columns=[f"材料{i+1}" for i in range(10)] + ["产物磨损"]
        )

        # 显示前1000条结果
        st.dataframe(df.head(1000), height=600)

        # 导出功能
        st.subheader("结果导出")
        
        # 生成Excel文件
        output = BytesIO()
        with pd.ExcelWriter(output, engine='openpyxl') as writer:
            df.to_excel(writer, index=False)
        output.seek(0)

        st.download_button(
            label="下载Excel文件",
            data=output,
            file_name="results.xlsx",
            mime="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
    else:
        st.warning("未找到符合条件的组合！")