# LinuxHub Public Container Registry

## 直接使用

### 使用前必看

服务器存储空间比较小，如果你下载了不常用的大镜像，麻烦去<https://lhcr.coolrc.me>手动删除掉，我们会定期清除镜像缓存

镜像代理地址：

- <https://lhcr.coolrc.me> 主registry
- <https://gcr.lhcr.coolrc.me> gcr.io代理
- <https://k8s-gcr.lhcr.coolrc.me> k8s.gcr.io代理
- <https://ghcr.lhcr.coolrc.me> ghcr.io代理

### docker 使用 (不推荐，建议使用podman)

docker不支持直接配置镜像代理，只能用最原始的方法，手动替换url使用：

比如你本来要这个镜像

```shell
docker pull ghcr.io/linuxhub-group/caddy:latest
```

现在可以这样

```shell
docker pull ghcr.lhcr.coolrc.me/linuxhub-group/caddy:latest
```

替换前面的地址就可以了

### Podman使用 (墙裂推荐)

关于从docker到podman的迁移请看这个：[从docker迁移到podman，支持docker-compose](https://coolrc.me/2021/09/05/202109051825/)

Podman支持为不同registry设置代理，修改`/etc/containers/registries.conf`配置方式如下：

```conf
unqualified-search-registries = ['docker.io', 'k8s.gcr.io', 'gcr.io', 'ghcr.io', 'quay.io']

[[registry]]
prefix = "k8s.gcr.io"
location = "k8s.gcr.io"

[[registry.mirror]]
location = "k8s-gcr.lhcr.coolrc.me"

[[registry]]
prefix = "gcr.io"
location = "gcr.io"

[[registry.mirror]]
location = "gcr.lhcr.coolrc.me"

[[registry]]
prefix = "ghcr.io"
location = "ghcr.io"

[[registry.mirror]]
location = "ghcr.lhcr.coolrc.me"
```

### Containerd

编辑`/etc/containerd/config.toml`

```toml
    [plugins."io.containerd.grpc.v1.cri".registry]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."k8s.gcr.io"]
          endpoint = ["https://k8s-gcr.lhcr.coolrc.me"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."gcr.io"]
          endpoint = ["https://gcr.lhcr.coolrc.me"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."ghcr.io"]
          endpoint = ["https://ghcr.lhcr.coolrc.me"]
```

然后重启Containerd：

```shell
systemctl restart containerd.service
```

## 部署

将`.env.example`修改为`.env`文件，填入你的email和[cloudflare api token](https://dash.cloudflare.com/profile/api-tokens) (用于自动获取证书)
使用项目提供的Caddyfile进行反代

如果需要定期清理，可以把`disk_usage.sh`加入corn job,(`disk_usage.sh`只会清理已经在ui里软删除的文件)。

## 感谢

- 感谢 <https://zhuanlan.zhihu.com/p/352870804> 的使用教程
- 感谢原作者提出的方案
- 感谢热心群友赞助的服务器
