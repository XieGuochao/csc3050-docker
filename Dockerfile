FROM archlinux
RUN echo 'Server = https://mirrors.cloud.tencent.com/archlinux/$repo/os/$arch' | tee /etc/pacman.d/mirrorlist  && \
    printf '\n[archlinuxcn]\nServer = https://mirrors.cloud.tencent.com/archlinuxcn/$arch\n' | tee -a /etc/pacman.conf
RUN pacman-key --init && pacman-key --populate && pacman -Syyu --noconfirm archlinuxcn-keyring 
RUN pacman -S --noconfirm pikaur base-devel cmake ninja clang gdb lldb iverilog fish python nano vim emacs-nox

RUN useradd -m csc3050 && \
	echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	echo "csc3050 ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
	echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
	locale-gen

ENV LANG=en_US.utf8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=en_US.UTF-8
RUN sudo -u csc3050 env HTTP_PROXY="$HTTP_PROXY" HTTPS_PROXY="$HTTPS_PROXY"  pikaur -S --noconfirm --color=always code-server
RUN pacman -Sc --noconfirm && chsh -s /usr/bin/fish csc3050

EXPOSE 3050

ENV PASSWORD=csc3050

USER csc3050

CMD ["code-server", "--bind-addr", "0.0.0.0:3050", "--auth", "password"]

