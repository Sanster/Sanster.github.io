title: Python import 机制
date: 2018-06-20 10:02
category: Language
tags: Python
---

原文：[The Definitive Guide to Python import Statements](https://chrisyeh96.github.io/2017/08/08/definitive-guide-python-imports.html)

一直对 Python 的 import 机制感到很混乱，这篇 blog 通过一个示例项目涵盖在 python3 中 import 机制的各种情况。

示例项目地址：https://github.com/Sanster/python_import_example

```bash
python_import_example
├── packA
│   ├── a1.py
│   ├── a2.py
│   ├── __init__.py
│   └── subA
│       ├── __init__.py
│       ├── sa1.py
│       └── sa2.py
├── packB
│   ├── b1.py
│   └── b2.py
├── other.py
├── math.py
├── random.py
├── README.md
└── start.py
```

<!--more-->

@[toc]

# 基本定义

- module：任何 `*.py` 文件，模块名即为文件名
- build-in module：python 内置的 module，通过 C 语言编写，在 import 时总是有最高的优先级，例如 `math`, `sys` 等。可通过 `sys.builtin_module_name` 查看
- standard library：python 的标准库，入 `random`
- package：任何包含 `__init__.py` 文件的目录包名即为目录名。（python3.3 以上，不包含 `__init__.py` 文件的文件夹也会被认为是包）

# 要点

- `import` 会在 `sys.path` 中进行搜索可用的 module/package
- `sys.path` 总会包含被执行脚本所在的目录，但是**不会**包含当前的工作目录。
- `import` module 时，会执行 module 中的代码， `import` 一个 package 时会执行 `__init__.py` 中的代码

# import 时的搜索顺序

以 `import spam`  为例：

- 在 build-in module 中搜索 module
- 在 `sys.path` 中搜索文件 `spam.py`或者文件夹 `spam` . `sys.path` 由以下路径组成
  - 如果是执行一个 python 脚本，则 `sys.path[0]` 为**被执行脚本所在的目录**，执行 `python3 packA/a1.py` 会看到 `python_import_example/packA` 目录位于起始位置
  - 如果实在 python 交互式环境里，则 `sys.path[0]` 为空字符串
  - `PYTHONPATH` 环境变量
  - python 的依赖库目录

`start.py` 中的 `import math` 总会去 import 属于 build-in module 的 math 模块，而不是当前目录的 `math.py` 文件。
而 `import random` 则会 import 当前目录下的 `random.py`，执行 `python3 start.py` 会看到只有 `random.py` 中的输出：
```bash
random module in python_import_example
```

所有 import 的模块都会共享 `sys.path`。例如，执行 `python3 start.py`，则 `sys.path` 中会包含 `python_import_example/` 目录，
在 `start.py` 中 import 了 `packA.a1` 模块，所以在 `a1.py` 中可以直接 `import other`：
```bash
import other module in packA/a1.py
other module in python_import_exampl
```

# \_\_init\_\_.py 文件

`__init__.py` 文件主要有两个作用

**1. 使一个文件夹可以 import（python 3.3 之后，不包含 \_\_init\_\_.py 的文件夹也可以直接 import）**

如果使用 python 3.3 以上的版本执行 `start.py`，可以看到如下输出
```bash
<module 'packA' from '/home/cwq/code/python_import_example/packA/__init__.py'>
<module 'packB' (namespace)>
```

如果使用 python 3.3 以下的版本执行 `start.py` 则会报错：
```bash
ImportError: No module named packB
```

**2. import package 时，\_\_init\_\_.py 文件将会被执行，可以放一些 package 的初始化代码**

在 packA 的 \_\_init\_\_.py 文件里 import 了 a1.py 中的 `a1_func()` 函数，并且定义了 `packA_func()` 函数，
所以 import 了 packA 以后可以直接调用这两个函数：
```python
import packA  # "import packA.a1" 效果一样

packA.packA_func()
packA.a1_func()
packA.a1.a1_func()
```

执行 `python3 start.py` 可以看到如下输出：
```bash
running packA_func()
running a1_func()
running a1_func()
```

只有当 package 被 import 时，\_\_init\_\_.py 才会被执行，如果是在 `packA/` 目录下直接执行 `python3 a1.py`，
\_\_init\_\_.py 文件不会被执行。

# 使用 Module/Package 中的对象
四种 import 的方式：
1. `import <package>`
1. `import <module>`
1. `from <package> import <module or subpackage or object>`
1. `from <module> import <object>`

可已使用 `as Y` 给 import 的对象取别名，一个常用的例子如 `import numpy as np`。

以在 `start.py` 中导入 `sa1.py` 中的 `helloWorld()` 函数为例，有以下几种导入和使用方式：
1. `from packA.subA.sa1 import helloWorld` 
	- 使用方式：`helloWorld()`
1. `from packA.subA import sa1` 等价于 `import packA.subA.sa1 as sa1`
	- 使用方式：`sa1.helloWorld()`
1. `import packA.subA.sa1`
	- 使用方式：`packA.subA.sa1.helloWorld()`

# Absolute vs. Relative Import
**Absolute import** 以 module/package 开头，只用完整的路径来 import 需要的 module/package。

**Explicit relative import** 只能使用 `from .<module/package> import X` 这种形式，`.` 表示从文件所在的当前路径开始搜索，
`..` 表示从文件的上层目录开始搜索，在 `start.py` 中 import a1，在 a1 中 import `other`，`a2`，`sa1` 模块，则 `a1.py` 中
可以用如下形式导入：
- absolute imports:
```python
import other
import packA.a2
import packA.subA.sa1
```

- explicit relative imports:
```python
import other
from . import a2
from .subA import sa1
```
这里 import other 模块也使用了 absolute import，因为 relative import 的**顶层目录只能到被执行脚本的下一层**，执行 `python3 start.py`，
则 relative import 的搜索目录不能到 `python_import_example/` 这一层，
如果写成 `from .. import other` 就会报错 `ValueError: attempted relative import beyond top-level package`

# Case1: a2 既可被 import，也可被执行
要达到的效果：`start.py` import `a2`，`a2` import `sa2`，并且 `start.py` 和 `a2.py` 都可以直接运行。

按照不同脚本执行方式和 `a2.py` 中不同的 import 方式列出下列表格：
| Run/Import method | from packA.subA import sa2 | from subA import sa2 |
|-------------------|------------------------------|----------------------|
| `python3 start.py`   |             OK            | Error(No module named 'subA') |
| `python3 a2.py`      | Error(No module named 'packA') |         OK           |
| `python3 packA/a2.py`|             OK            |         OK        |

如果想要使 `python3 start.py` 和 `python3 a2.py` 都能够运行，则需要在 `a2.py` 中改变 `sys.path` 的值：

```python
import os, sys
sys.path.append(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))

# now this works, even when a2.py is run directly
from packA.subA import sa2
```

# Case2: Importing from Parent Directory

在不修改 `sys.path` 和 `PYTHONPATH` 的情况下，直接运行一个脚本时，不可能 import 父目录的任何 module/package.
具体原因在[Absolute vs. Relative Import](#absolute-vs-relative-import) 一节中有说明