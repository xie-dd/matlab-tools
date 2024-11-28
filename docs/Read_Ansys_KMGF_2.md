---
title: Read_Ansys_KMGF_2
---

## Description
获取Ansys刚度质量阻尼矩阵(结点与显示的匹配)
## Input:
- KFfile:刚度矩阵文件名称
## Output:
- K_new: 刚度矩阵
- F_new: 右端项
## Note
获取Ansys刚度质量阻尼矩阵(结点与显示的匹配)
https://www.yuque.com/docs/share/23fb9302-72ad-4ab4-ab0a-da341e8a2b88?# 《关于Ansys输出的刚度矩阵文件说明》
文件第二行数据为 43 7 5 15 15 6
数值行共有43行（7+5+15+15+6），7个行指针数据（K为6*6），5个列指针数据
15个非零矩阵元素，右端项有6行（0也会列出） F:6*1
