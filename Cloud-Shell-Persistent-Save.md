# Cloud Shell Persistent Save

## এই ফাইলটি কেন

এই গাইডটি তাদের জন্য, যারা Google Cloud Shell-এর persistent storage-এ Docker image save করে রাখতে চান, যাতে পরের দিন আবার run করার সময় Docker Hub থেকে আবার download করতে না হয়।

## সহজভাবে মূল কথা

- `docker save` করলে Docker image save হয়
- image save থাকলে পরে `docker load` করে তুলনামূলক দ্রুত run করা যায়
- কিন্তু `docker save` করলে GitHub repo folder save হয় না
- `ngrok` token-ও এই image tar file-এর ভিতরে save হয় না
- তাই পরের দিন সাধারণত `ngrok` token আবার দিতে হয়

## গুরুত্বপূর্ণ নোট

- image save হবে আপনার Cloud Shell home directory-তে
- পরে Cloud Shell reset হলেও home directory-র file সাধারণত থেকে যায়
- startup আগের চেয়ে দ্রুত হতে পারে, কিন্তু একদম সাথে সাথে হবে না, কারণ `docker load` করতেও কিছু সময় লাগে
- project-এর scripts ঠিকমতো Ubuntu desktop, VNC, noVNC, ngrok tunnel চালায়, তাই run করার সময় script ব্যবহার করাই ভালো

## ১. প্রথমে image save করে রাখুন

এই command গুলো তখন চালাবেন, যখন আপনার image ready আছে:

```bash
cd /tmp
rm -rf Ubuntu
git clone https://github.com/MasudRana0q/Ubuntu.git
cd Ubuntu
chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh web-tunnel.sh tcp-tunnel.sh setup-ngrok.sh scripts/docker-common.sh scripts/ngrok-common.sh scripts/start-vnc.sh
docker pull masudgolp/ubuntu-desktop-vnc:latest
docker save -o ~/ubuntu-desktop-vnc.tar masudgolp/ubuntu-desktop-vnc:latest
ls -lh ~/ubuntu-desktop-vnc.tar
```

## ২. পরের দিন mobile mode-এ কীভাবে run করবেন

Cloud Shell reset হওয়ার পরে এই command গুলো চালাবেন:

```bash
cd /tmp
rm -rf Ubuntu
git clone https://github.com/MasudRana0q/Ubuntu.git
cd Ubuntu
chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh web-tunnel.sh tcp-tunnel.sh setup-ngrok.sh scripts/docker-common.sh scripts/ngrok-common.sh scripts/start-vnc.sh
docker load -i ~/ubuntu-desktop-vnc.tar
./setup-ngrok.sh YOUR_NGROK_AUTHTOKEN
HOST_UPLOAD_FOLDER=$HOME/cloudshell-uploads IMAGE_NAME=masudgolp/ubuntu-desktop-vnc ./start.sh mobile
```

## ৩. যদি mobile tunnel দরকার না হয়

```bash
cd /tmp
rm -rf Ubuntu
git clone https://github.com/MasudRana0q/Ubuntu.git
cd Ubuntu
chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh web-tunnel.sh tcp-tunnel.sh setup-ngrok.sh scripts/docker-common.sh scripts/ngrok-common.sh scripts/start-vnc.sh
docker load -i ~/ubuntu-desktop-vnc.tar
HOST_UPLOAD_FOLDER=$HOME/cloudshell-uploads IMAGE_NAME=masudgolp/ubuntu-desktop-vnc ./start.sh
```

## ৪. কীভাবে stop করবেন

```bash
cd /tmp/Ubuntu
./stop.sh
```

## ৫. stop করার পরে আবার start করবেন কীভাবে

যদি mobile-এর জন্য চালাতে চান:

```bash
cd /tmp/Ubuntu
HOST_UPLOAD_FOLDER=$HOME/cloudshell-uploads IMAGE_NAME=masudgolp/ubuntu-desktop-vnc ./start.sh mobile
```

যদি mobile tunnel ছাড়া শুধু Ubuntu desktop চালাতে চান:

```bash
cd /tmp/Ubuntu
HOST_UPLOAD_FOLDER=$HOME/cloudshell-uploads IMAGE_NAME=masudgolp/ubuntu-desktop-vnc ./start.sh
```

## ৬. ngrok token কি আবার দিতে হবে

হ্যাঁ, বেশিরভাগ ক্ষেত্রে আবার দিতে হবে।

কারণ:

- project `ngrok` token save করে `/tmp/.ngrok` folder-এ
- Cloud Shell reset হলে `/tmp` সাধারণত খালি হয়ে যায়
- তাই next day run করলে সাধারণত এই command আবার চালাতে হবে:

```bash
./setup-ngrok.sh YOUR_NGROK_AUTHTOKEN
```

## ৭. git clone আবার কেন দিতে হচ্ছে

কারণ `docker save` শুধু Docker image save করে।

এটা save করে না:

- GitHub repo folder
- `start.sh`, `stop.sh`, `setup-ngrok.sh` এর working copy
- `/tmp` folder-এর ভিতরের temporary files

তাই `docker save` করে রাখলেও পরে repo আবার লাগবে, কারণ run করার সময় project-এর script দরকার হয়।

## ৮. git clone কি save হয়ে থাকবে

না, `docker save`-এর সাথে GitHub clone save হয়ে থাকবে না।

কারণ:

- repo আপনি clone করছেন `/tmp/Ubuntu`-তে
- `/tmp` persistent storage না
- Cloud Shell reset হলে `/tmp/Ubuntu` মুছে যেতে পারে

## ৯. তাহলে git clone ছাড়া কি করা যায়

হ্যাঁ, চাইলে repo-টাও আলাদা করে persistent storage-এ tar file হিসেবে save করে রাখতে পারেন।

তাহলে পরের দিন আবার GitHub থেকে download না করে tar file extract করে ব্যবহার করতে পারবেন।

## ১০. repo-টাও save করে রাখতে চাইলে

একবার save করুন:

```bash
cd /tmp
rm -rf Ubuntu
git clone https://github.com/MasudRana0q/Ubuntu.git
tar -czf ~/Ubuntu-repo.tar.gz Ubuntu
ls -lh ~/Ubuntu-repo.tar.gz
```

## ১১. পরের দিন git clone ছাড়া repo restore করবেন যেভাবে

```bash
cd /tmp
rm -rf Ubuntu
tar -xzf ~/Ubuntu-repo.tar.gz
cd Ubuntu
chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh web-tunnel.sh tcp-tunnel.sh setup-ngrok.sh scripts/docker-common.sh scripts/ngrok-common.sh scripts/start-vnc.sh
docker load -i ~/ubuntu-desktop-vnc.tar
./setup-ngrok.sh YOUR_NGROK_AUTHTOKEN
HOST_UPLOAD_FOLDER=$HOME/cloudshell-uploads IMAGE_NAME=masudgolp/ubuntu-desktop-vnc ./start.sh mobile
```

## ১২. কখন আবার নতুন করে save করবেন

এই file-গুলোর যেকোনো একটায় change করলে নতুন করে image save করা ভালো:

- `Dockerfile`
- `scripts/start-vnc.sh`
- `scripts/docker-common.sh`
- `scripts/ngrok-common.sh`
- Firefox, VNC, desktop, package, startup behavior সম্পর্কিত যেকোনো change
