#!/bin/bash

# ========================================
# YOLOv5 + オブジェクト検出 + 音声BGM生成
# 開発環境セットアップスクリプト
# ========================================

set -e

echo "🔧 開発環境セットアップを開始します..."

# Python バージョン確認
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "✓ Python バージョン: $PYTHON_VERSION"

# 仮想環境作成
if [ ! -d "venv" ]; then
    echo "📦 仮想環境を作成中..."
    python3 -m venv venv
else
    echo "✓ 仮想環境が既に存在します"
fi

# 仮想環境をアクティベート
echo "🔌 仮想環境をアクティベート中..."
source venv/bin/activate

# pip をアップグレード
echo "📦 pip をアップグレード中..."
pip install --upgrade pip setuptools wheel

# ========================================
# PyTorch インストール (CPU版)
# ========================================
echo "📥 PyTorch (CPU版) をインストール中..."
pip install torch==2.8.0 torchvision==0.17.0 --index-url https://download.pytorch.org/whl/cpu

# ========================================
# YOLOv5 リポジトリのクローン
# ========================================
if [ ! -d "yolov5" ]; then
    echo "📥 YOLOv5 をクローン中..."
    git clone https://github.com/ultralytics/yolov5.git
else
    echo "✓ YOLOv5 が既に存在します"
fi

# ========================================
# 基本ライブラリのインストール
# ========================================
echo "📥 基本ライブラリをインストール中..."

# NumPy 安定版 (1.26.4 推奨)
pip install "numpy>=1.24,<2.0"

# OpenCV
pip install opencv-python

# 科学計算・信号処理
pip install scipy scikit-learn

# オーディオ関連
pip install sounddevice

# 自然言語処理
pip install sentence-transformers

# Jupyter環境
pip install jupyter jupyterlab ipywidgets

# 可視化
pip install matplotlib

# ========================================
# YOLOv5 依存関係のインストール
# ========================================
echo "📥 YOLOv5 依存関係をインストール中..."
cd yolov5
pip install -r requirements.txt
cd ..

# ========================================
# データディレクトリの作成
# ========================================
if [ ! -d "data" ]; then
    echo "📁 data ディレクトリを作成中..."
    mkdir -p data
else
    echo "✓ data ディレクトリが既に存在します"
fi

# ========================================
# 環境確認
# ========================================
echo ""
echo "✅ セットアップが完了しました！"
echo ""
echo "📝 次のステップ:"
echo "  1. 仮想環境をアクティベート:"
echo "     source venv/bin/activate"
echo ""
echo "  2. サンプルデータを data/ ディレクトリに配置してください"
echo "     （NHK公開動画など）"
echo ""
echo "  3. Jupyter を起動:"
echo "     jupyter lab"
echo ""
echo "  4. work.ipynb を実行"
echo ""
echo "🔗 YOLOv5: https://github.com/ultralytics/yolov5"
echo "🔗 PyTorch: https://pytorch.org/get-started/locally/"