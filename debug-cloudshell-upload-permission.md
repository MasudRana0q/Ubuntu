[OPEN] CloudShell upload permission debug

Session ID: cloudshell-upload-permission

Symptoms:
- Ubuntu desktop থেকে `CloudShell-Uploads` shortcut খুললে `Permission denied` দেখায়
- Docker Hub থেকে নতুন image pull/rebuild করার পরেও সমস্যা থাকে

Hypotheses:
1. Host side folder (`$HOME`) Cloud Shell-এ restrictive permission (`700`) এ আছে, তাই container user `ubuntu` bind mount path-এ ঢুকতে পারছে না।
2. Shortcut target `/cloudshell-uploads` ঠিক আছে, কিন্তু bind-mounted directory owner/UID container-এর `ubuntu` user-এর সাথে match করছে না।
3. Desktop shortcut symlink/launcher path ঠিকমতো resolve হচ্ছে না এবং file manager symlink target-এ access deny দেখাচ্ছে।
4. Host root folder mount করা হয়েছে (`$HOME`), কিন্তু usable subfolder (`$HOME/cloudshell-uploads`) mount করা হয়নি।

Planned evidence:
- Docker image user/UID check
- Mounted host path choice check
- Cloud Shell host directory permission check
- Container side path ownership check
