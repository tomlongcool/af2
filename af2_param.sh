#!/usr/bin/env bash
#
# Copyright 2021 DeepMind Technologies Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Downloads and unzips the AlphaFold parameters (wget version).
#
# Usage:
#   bash download_alphafold_params.sh /path/to/download/directory
#
set -euo pipefail

# ────────────────────────── 1. 参数检查 ──────────────────────────
if [[ $# -eq 0 ]]; then
  echo "Error: download directory must be provided as an input argument." >&2
  exit 1
fi

if ! command -v wget &> /dev/null; then
  echo "Error: wget could not be found. Please install wget (e.g. sudo apt install wget)." >&2
  exit 1
fi

# ────────────────────────── 2. 变量定义 ──────────────────────────
DOWNLOAD_DIR="$1"
ROOT_DIR="${DOWNLOAD_DIR}/params"
SOURCE_URL="https://storage.googleapis.com/alphafold/alphafold_params_2022-12-06.tar"
BASENAME="$(basename "${SOURCE_URL}")"
TARGET_PATH="${ROOT_DIR}/${BASENAME}"

# ────────────────────────── 3. 创建目录 ──────────────────────────
mkdir -p "${ROOT_DIR}"

# ────────────────────────── 4. 下载文件 ──────────────────────────
#  -c / --continue   : 断点续传
#  -O                : 指定输出文件名
#  --show-progress   : 显示进度条（GNU Wget 1.20+）
wget --continue --show-progress -O "${TARGET_PATH}" "${SOURCE_URL}"

# ────────────────────────── 5. 解压并清理 ──────────────────────────
tar --extract --verbose --file="${TARGET_PATH}" \
    --directory="${ROOT_DIR}" --preserve-permissions

rm -f "${TARGET_PATH}"

echo "AlphaFold parameters downloaded and extracted to: ${ROOT_DIR}"
