

এবার সুন্দর কাজ হয়েছে আমার সব রানীকে সিস্টেম এখন বিল্ড করা আছে এই বিল্ড করা অপারেটিং সিস্টেমকে docker hub এ পুশ করে রাখতে পারব কি যাতে করে পরবর্তীতে শুধুমাত্র ডাউনলোড হয় এবং রান হয় ?

**Assistant**

হ্যাঁ, পারবেন। এটা খুব ভালো approach।

**আপনার জন্য best workflow**
- একবার image build করবেন
- Docker Hub-এ push করবেন
- পরে Cloud Shell-এ শুধু pull + run করবেন
- এতে 15-20 মিনিট build time আর লাগবে না

**আপনার repo/image name**
- Docker Hub username: `masudgolp`
- আমি recommend করছি image name: `masudgolp/ubuntu-desktop-vnc:latest`

**এখন কী করতে হবে**

**১. Cloud Shell-এ built image tag দিন**
```bash
docker tag ubuntu-desktop-vnc:latest masudgolp/ubuntu-desktop-vnc:latest
```

**২. Docker Hub login করুন**
```bash
docker login -u masudgolp
```

**৩. Docker Hub-এ push করুন**
```bash
docker push masudgolp/ubuntu-desktop-vnc:latest
```

**এরপর ভবিষ্যতে Cloud Shell-এ build ছাড়াই চালাবেন**
```bash
cd /tmp

docker stop ubuntu-desktop-vnc 2>/dev/null
docker rm ubuntu-desktop-vnc 2>/dev/null

rm -rf Ubuntu

git clone https://github.com/MasudRana0q/Ubuntu.git
cd Ubuntu

chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh web-tunnel.sh tcp-tunnel.sh setup-ngrok.sh scripts/docker-common.sh scripts/ngrok-common.sh scripts/start-vnc.sh

./setup-ngrok.sh YOUR_NGROK_AUTHTOKEN

HOST_UPLOAD_FOLDER=$HOME IMAGE_NAME=masudgolp/ubuntu-desktop-vnc ./start.sh mobile-pull
```

**এখানে কী হবে**
- `IMAGE_NAME=masudgolp/ubuntu-desktop-vnc`
- script আর local build করবে না
- Docker Hub থেকে image pull করবে
- তারপর run করবে
- তারপর ngrok TCP tunnel খুলবে

**খুব গুরুত্বপূর্ণ**
- যখনই আপনি `Dockerfile`, [Dockerfile](file:///d:/Projects/Ubuntu/Dockerfile), [start-vnc.sh](file:///d:/Projects/Ubuntu/scripts/start-vnc.sh), [supervisord.conf](file:///d:/Projects/Ubuntu/config/supervisord.conf) বা related system file change করবেন:
  - আবার build করতে হবে
  - আবার নতুন image push করতে হবে

**নতুন version push করার flow**
```bash
cd /tmp/Ubuntu

./start.sh rebuild

docker tag ubuntu-desktop-vnc:latest masudgolp/ubuntu-desktop-vnc:latest
docker push masudgolp/ubuntu-desktop-vnc:latest
```

**আরও ভালো practice**
আপনি চাইলে version tag-ও দিতে পারেন:

```bash
docker tag ubuntu-desktop-vnc:latest masudgolp/ubuntu-desktop-vnc:v1
docker push masudgolp/ubuntu-desktop-vnc:v1
docker push masudgolp/ubuntu-desktop-vnc:latest
```

**আমার recommendation**
- `latest` রাখুন easy use-এর জন্য
- সাথে `v1`, `v2` এর মতো version tag রাখুন backup-এর জন্য

**আপনার future easy command**
- build ছাড়া run:

```bash
HOST_UPLOAD_FOLDER=$HOME IMAGE_NAME=masudgolp/ubuntu-desktop-vnc ./start.sh mobile-pull
```

চাইলে next message-এ আমি আপনাকে একদম final ২টা ready block দেব:
- ১টা Docker Hub-এ push করার জন্য
- ১টা future-এ শুধু pull + run করার জন্য

---

