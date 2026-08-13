# YOLOv5 オブジェクト検出 + 音声BGM生成システム

高精度な物体検出（YOLOv5）と、検出結果をリアルタイムで音声に変換する革新的なシステムです。
検出された物体の種類・出現時間・信頼度を**メジャーコード（3音の調和）** で表現した BGM を自動生成します。

## 🎯 プロジェクト概要

### 主な機能

| 機能 | 説明 |
|------|------|
| **YOLOv5 物体検出** | リアルタイム で人・車・動物など 9 クラスを検出 |
| **多層可視化** | 検出枠・時間軸・マッピング・カラースケール 4 パネル表示 |
| **イベントベース音声生成** | 連続検出をイベント化 → メジャーコード→ADSR エンベロープ |
| **音響美学** | 信頼度ベースの周波数・音量変調 + 低周波ブースト |

### 検出クラス（9種）

```python
'person'(C4), 'bicycle'(D4), 'car'(E4), 'motorbike'(F4),
'bus'(G4), 'truck'(A4), 'dog'(C5), 'cat'(D5), 'horse'(E5)
```

各クラスは**ペンタトニックスケール** に配置され、異なる周波数で表現されます。

---

## 🚀 クイックスタート

### 1. 環境セットアップ（自動）

```bash
# プロジェクトディレクトリで実行
bash setup.sh
```

このスクリプトが自動的に以下を実行します：
- Python 仮想環境の作成
- PyTorch (CPU版) のインストール
- YOLOv5 リポジトリのクローン
- 全依存ライブラリのインストール
- データディレクトリの作成

### 2. サンプルデータの準備

以下のいずれかから動画ファイルを取得し、`data/` ディレクトリに配置します：

```bash
# 例: sample.mp4 を data/ に配置
mkdir -p data
cp /path/to/video.mp4 data/sample.mp4
```

推奨サンプル:
- NHK 公開映像（街頭シーン）
- YouTubeの街頭動画

### 3. Jupyter を起動

```bash
# 仮想環境をアクティベート（セットアップスクリプトで既に有効な場合はスキップ）
source venv/bin/activate

# Jupyter Lab を起動
jupyter lab
```

### 4. ノートブックを実行

ブラウザで `http://localhost:8888` を開き、以下を実行：

1. **`work.ipynb`** - メイン処理（推奨）
   - セル 1-3: ライブラリ・モデルロード
   - セル 4-5: ユーティリティ関数
   - セル 8: 音声生成モジュール
   - セル 9-11: 可視化関数
   - セル 12: **メイン処理ループ** ← ここを実行
   - セル 13: 診断（必要に応じて）

2. **`sample.ipynb`** - 軽量版（基本動作確認用）

---

## 📦 システム要件

| 項目 | 要件 |
|------|------|
| **OS** | macOS / Linux / Windows |
| **Python** | 3.9+ |
| **RAM** | 4GB 以上（推奨 8GB） |
| **GPU** | 不要（CPU のみで動作） |
| **動画サンプル** | 640×480 以上、MP4 推奨 |

---

## 🔧 インストール済みライブラリ

### 深層学習
- **PyTorch 2.8.0** (CPU版)
- **YOLOv5** (Ultralytics)

### 画像・動画処理
- **OpenCV** - フレーム処理・描画
- **NumPy 1.26.x** - 数値計算（NumPy 2.x との互換性対応済み）

### 音響合成
- **SciPy** - wav ファイルI/O、フィルタ設計
- **sounddevice** - リアルタイム音響再生

### 機械学習・分析
- **scikit-learn** - MDS 次元削減
- **sentence-transformers** - テキスト埋め込み（物体クラスの類似度計算）

### Jupyter / UI
- **Jupyter Lab**
- **ipywidgets** - プログレスバー表示

---

## 🎵 音声生成のしくみ

### アーキテクチャ: イベントベースシーケンサー

```
フレーム列
  ↓ (連続検出を集約)
イベント抽出
  ├─ イベント A: person, フレーム 10-20 (333ms), スコア 0.95
  ├─ イベント B: car, フレーム 15-40 (833ms), スコア 0.87
  └─ イベント C: dog, フレーム 50-55 (250ms), スコア 0.72
  ↓
シーケンサーで音声生成
  ├─ 各イベント → メジャーコード（3音の調和）生成
  ├─ ADSR エンベロープ適用（Attack/Decay/Sustain/Release）
  ├─ 信頼度ベースの周波数・音量変調
  └─ イベント間でブレンド（オーバーラップサポート）
  ↓
BGM 出力（WAV ファイル）
```

### 音響特性

| パラメータ | 値 | 説明 |
|-----------|-----|------|
| サンプリングレート | 44,100 Hz | CD 品質 |
| フォーマット | int16 WAV | 標準オーディオ |
| メジャーコード比率 | 1:1.26:1.5 | 音階学的な調和 |
| ADSR | 0.05/0.1/0.6/0.1 (秒) | スムーズなエンベロープ |
| 低周波ブースト | 800 Hz LPF | 温かみのある音質 |

### 周波数マッピング

```
物体クラス     基本周波数    五線譜
──────────────────────────────
person         262 Hz (C4)   ド
bicycle        294 Hz (D4)   レ
car            330 Hz (E4)   ミ
motorbike      349 Hz (F4)   ファ
bus            392 Hz (G4)   ソ
truck          440 Hz (A4)   ラ
dog            523 Hz (C5)   ド（1オクターブ上）
cat            587 Hz (D5)   レ（1オクターブ上）
horse          659 Hz (E5)   ミ（1オクターブ上）
```

---

## 📊 出力ファイル

実行後、以下のファイルが生成されます：

```
output_color_<timestamp>.mp4    ← 可視化付き動画（推奨）
output_mono_<timestamp>.mp4     ← グレースケール版
detection_bgm_color.wav         ← 音声 BGM ファイル
```

### 動画の構成（4 パネルレイアウト）

```
┌───────────────────────┬──────────────────┐
│                       │                  │
│  メイン検出パネル      │ 縦方向時間軸    │
│  (960×480px)         │ (320×480px)     │
│                       │                  │
├───────────────────────┼──────────────────┤
│                       │                  │
│ カラースケール        │ 横方向時間軸     │
│ (320×320px)          │ (640×320px)     │
│                       │                  │
└───────────────────────┴──────────────────┘
```

各パネルの説明：
- **メイン検出** - 物体の検出枠・円・接続線 + 過去 30 フレームの軌跡
- **縦方向時間軸** - Y座標 vs フレーム時間
- **横方向時間軸** - X座標 vs フレーム時間
- **カラースケール** - クラス → 色相・角度のマッピング

---

## 🔍 トラブルシューティング

### 問題 1: `RuntimeError: Numpy is not available`

**原因**: PyTorch が NumPy サポートなしでビルドされた wheel を使用

**解決**:
```bash
pip install --upgrade "numpy>=1.24,<2.0"
```

> 設定済み: `setup.sh` で自動対応

### 問題 2: `ImportError: IProgress not found`

**原因**: Jupyter / ipywidgets の不完全インストール

**解決**:
```bash
pip install --upgrade jupyter jupyterlab ipywidgets
```

> 設定済み: `setup.sh` で自動対応

### 問題 3: Kernel の古い関数をキャッシュ

**症状**: コード修正後も古いエラーが出る

**解決**: Jupyter カーネルを再起動
- メニュー → **Kernel** → **Restart Kernel** → **Restart**

### 問題 4: GPU メモリ不足

**症状**: CUDA エラー（GPU を使用している場合）

**解決**: CPU 強制を確認
```python
device='cpu'  # work.ipynb のセル 3 で既に設定
```

### 問題 5: 動画ファイルが開けない

**症状**: `cv2.VideoCapture` が失敗

**確認事項**:
- ファイルパスが正確か
- MP4 形式か（AVI/MOV は OpenCV で扱いにくい）
- ファイルが破損していないか

---

## 📈 パフォーマンス

Intel Core i7 (第 11 世代) + 16GB RAM での実測値

| タスク | 処理時間 |
|--------|---------|
| YOLOv5 推論（1フレーム、640×480） | 150～200 ms |
| 全フレーム検出（120 フレーム） | 18～24 秒 |
| 可視化フレーム生成 | 5～10 ms/フレーム |
| 音声 BGM 生成 | < 1 秒 |
| **動画全体処理** | **25～35 秒** |

---

## 🎨 カスタマイズ

### 周波数を変更する

[cell 8 内の `BASE_FREQUENCIES`] を編集：

```python
BASE_FREQUENCIES = {
    'person': 262,      # ← この値を変更
    'bicycle': 294,
    # ...
}
```

### ADSR エンベロープを調整する

[cell 8 内の `apply_adsr_envelope`] のパラメータを変更：

```python
chord = apply_adsr_envelope(
    chord, SAMPLE_RATE, duration,
    a=0.05,    # Attack (秒)
    d=0.1,     # Decay
    s=0.6,     # Sustain
    r=0.1      # Release
)
```

### イベント最小フレーム数を変更する

[cell 8 内の `create_bgm_from_results`] を編集：

```python
events = extract_detection_events(
    result_hist, class_names,
    min_consecutive_frames=2  # ← 値を増やすと長い音になる
)
```

---

## 📚 参考資料

| 項目 | リンク |
|------|--------|
| YOLOv5 公式 | https://github.com/ultralytics/yolov5 |
| PyTorch | https://pytorch.org/ |
| OpenCV | https://opencv.org/ |
| Sentence-Transformers | https://www.sbert.net/ |
| SciPy Signal Processing | https://docs.scipy.org/doc/scipy/reference/signal.html |

---

## 📝 ライセンス

- **YOLOv5**: AGPL-3.0 (Ultralytics)
- **このプロジェクト**: MIT License

---

## 👤 開発環境

- macOS 14.x / Python 3.11
- PyTorch 2.8.0 (CPU)
- Jupyter Lab 4.x