Docker 多阶段构建

在构建应用的时候，我们需要将源代码构建进去，对于编译类型的语言只需要把二进制包放进去即可，将源代码放进去会增大镜像体积。


目的： 将最终的可执行文件放到一个最小的镜像（alpine）中执行。

解决方案1： (plan01)
1. 从ubuntu镜像中下载代码
2. 在Ubuntu镜像中编译文件 （在专门的编译机器上进行编译，一般使用专门的镜像做编译）
3. 将编译完的文件通过volume挂载到主机上，然后将这个文件挂载到alpine镜像中去，打包镜像


解决方案2: (plan02) 多阶段编译
1. 要求docker版本大于17.05, 官方推出了新的特性: Multi-stage builds(多阶段构建)
2. 在一个dockerfile里面写多个阶段


tips

go完全静态编译: CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' .

