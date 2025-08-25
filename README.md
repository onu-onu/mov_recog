
## 環境構築
1. 仮想環境作成
    ```bash
    python3 -m venv venv
    . venv/bin/activate
    ```
1. YOLOv5のインストール
    ```bash
    git clone https://github.com/ultralytics/yolov5
    ```
1. ライブラリインストール
    ```bash
    pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
    cd yolov5/
    pip install -r requirements.txt
    pip install sentence-transformers scikit-learn
    ```

## サンプルデータ取得
1. 以下リンクからデータ取得 \
    https://www2.nhk.or.jp/archives/movies/?id=D0002060618_00000

1. `data/` ディレクトリ配下に配置

## サンプルコード実行
1. `sample.ipynb` を実行

## トラブルシュート
1. `RuntimeError: Numpy is not available` がでたとき
    ```bash
    pip install --upgrade "numpy>=1.24,<2.0"
    ```
    >PyTorch が numpy サポートなしでビルドされた wheel を拾っているのが原因です。(Mac M1 + Python3.11 だとよく起きます)\
    >numpy 1.26.4 を入れ直す（PyTorch 2.x + Python 3.11 で安定して動くバージョンです）\
    >by ChatGPT

    >ただし警告について\
    >opencv-python 4.12.0.88 requires numpy<2.3.0,>=2; python_version >= "3.9", but you have numpy 1.26.4 which is incompatible.
    >ここがややトリッキーです。\
    >OpenCV の最新ビルドは NumPy 2.x 系を前提 に作られていて、NumPy 1.x 系とは互換警告が出ています。
    >でも YOLOv5 + PyTorch の安定動作は NumPy 1.24〜1.26 系 が推奨。\
    >（NumPy 2.x 系はまだ多くのライブラリで動作未検証のため不具合が出やすい\
    >by ChatGPT

1. `ImportError: IProgress not found. Please update jupyter and ipywidgets` がでたとき
  ```bash
  pip install --upgrade jupyter ipywidgets
  ```