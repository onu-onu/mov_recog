
## 環境構築
1. 仮想環境作成
    ```
    python3 -m venv venv
    . venv/bin/activate
    ```
1. ライブラリインストール
    ```
    pip install -r requirements.txt
    ```
1. YOLOv5のインストール
    ```
    git clone https://github.com/ultralytics/yolov5
    ```

※上記をまとめた `setup.sh` を用意しました (macOS, Linux系のみ)

## サンプルデータ取得
1. 以下リンクからデータ取得 \
    https://www2.nhk.or.jp/archives/movies/?id=D0002060618_00000

1. `data/` ディレクトリ配下に配置

## サンプルコード実行
1. `sample.ipynb` を実行