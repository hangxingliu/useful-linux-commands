# Git

# 相关名词中英对照 Terminology zh-CN/en
## workspace: 工作区
## index(stage): 暂存区
## repository: 仓库区(本地仓库)
## remote: 远端(远程仓库)
## ---
## stash: 存档库 (为了某些操作, 临时存放一下变动)

# git log 可视化图表
# 一行样式
git log --graph --branches --all --decorate \
	--format=format:'%C(yellow)%h%C(auto)%d%C(white): %s %C(dim)(%ad)' \
	--date=format:'%m/%d'
# 双行样式
git log --graph --branches --all --decorate \
	--format=format:'%C(yellow)%h%C(reset) %C(green dim)%ad (%ar) %C(auto)%d%n    %C(white)%s%n' \
	--date=format:'%y-%m-%d %H:%M'
# 多行样式(带有commit body消息)
git log --graph --branches --all --decorate \
	--format=format:'%C(yellow)%h%C(reset) %C(green dim)%ad (%ar) %C(auto)%d%n    %C(white)%s%n%b' \
	--date=format:'%y-%m-%d %H:%M'
#git log format 语法
	%h # 提交Hash缩写
	%ad # 作者提交日期(--date的格式)
	%ar # 作者提交相对日期(一周前...)
	%an # 作者名字
	%d # ref标签 (HEAD, origin/master, .....)
	%s # 提交消息
	%b # 提交消息主体
	%n # 换行

# git默认编辑器改成VIM
git config --global core.editor vim
# git默认合并,差异工具改成Meld
git config --global diff.tool meld
git config --global merge.tool meld

# git默认提交时带上GPG签名
gpg --list-secret-keys --keyid-format LONG
git config --global user.signingkey KEY
git config --gloabl commit.gpgsign true


# 第一次上传git代码失败: fatal: 拒绝合并无关的历史
# fatal: refusing to merge unrelated histories
git pull --allow-unrelated-histories

# git reset mode:  重置(删除)本地commit
git reset --mixed # by default: reset files to working directory
# mixed 是默认模式, 重置到工作目录(文件系统)
git reset --soft # reset files to stage/index 重置到暂存区
git reset --hard # F**k your life mode: reset files to black hole(黑洞)
## for example:
git reset --soft HEAD^ # reset to last commit

# git delete local branch git删除本地分支:
git branch --delete <branch_name>
# replace `-d` to `-D` to delete branch un-merged (--force)

# git delete remote branch git删除远端分支
git push --delete <remote_name> <branch_name>
