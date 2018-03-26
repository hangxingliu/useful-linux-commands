# GPG
# encrypt and decrypt by command gpg

# 配置GPG
gpg --gen-key
gpg --list-secret-keys --keyid-format LONG
gpg --armor --export 3AA5C34371567BD2
gpg --armor --export 3AA5C34371567BD2
# 导出/备份私钥
gpg --armor --output gpg_sec_key.gpg --export-secret-keys 3AA5C34371567BD2
# 导入
gpg --import ~/mygpgkey_pub.gpg
gpg --allow-secret-key-import --import ~/mygpgkey_sec.gpg

# GPG 非对等加密
gpg --output file.gpg --encrypt --recipient xx@xx.com originalFile
# GPG 解密
gpg --output file --decrypt file.gpg

# GPG 对等(密码)加密
gpg -c filename
# GPG 对等加密的解密
gpg -d filename.gpg
