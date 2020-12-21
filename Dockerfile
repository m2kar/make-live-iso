# 在上一节中，我们将squashfs映像导入Docker中，镜像名为'ubuntulive:base'
FROM ubuntulive:base

# 设置环境变量，以便apt非交互地安装软件包
# 这些变量将仅在Docker中设置，而不在安装镜像中设置
ENV DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical

# =====================================================
# 进行一些修改，例如 安装谷歌浏览器
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update
RUN apt-get install -y google-chrome-stable

# ======================================================
# 安装重新包装ISO所需的软件包（我们将使用此映像重新包装自身）
# 安装BIOS支持：grub-pc-bin
# 安装EFI支持：grub-egi-amd64-bin and grub-efi-amd64-signed 
# 构建ISO：grub2-common, mtools and xorriso
# 其中xorriso在universe源
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN apt-get install -y grub2-common grub-pc-bin grub-efi-amd64-bin grub-efi-amd64-signed mtools xorriso

# 删除过时的软件包和任何临时状态
RUN apt-get autoremove -y && apt-get clean
RUN rm -rf \
    /tmp/* \
    /boot/* \
    /var/backups/* \
    /var/log/* \
    /var/run/* \
    /var/crash/* \
    /var/lib/apt/lists/* \
    ~/.bash_history

