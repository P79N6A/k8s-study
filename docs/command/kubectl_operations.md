| 操作类型     | 语法                                                         | 描述                                           |
| :----------- | ------------------------------------------------------------ | ---------------------------------------------- |
| annotate     | kubectl annotate (-f file \| type name ) key=val  【--all】【--resource-version=version】【flags】 | 增加或更新一个或者多个资源的注释               |
| api-versions | kubectl apiversion 【flags】                                 | 列出可用的API版本                              |
| apply        | kubectl apply -f filename 【flags】                          | 通过配置更改资源                               |
| attach       | kubectl attach pod -c container 【-i】【-t】【flags】        | 查看pod的某个容器的输入输出                    |
| autoscale    | kubectl autoscale (-f filename \| type name ) 【--min=MINPODS】 --max=MAXPODS 【--cpu-percent=CPU】 【flags】 | 扩容Pod                                        |
| cluster-info | kubectl cluster-info 【flags】                               | 显示集群中的信息                               |
| config       | kubectl config subcommand 【flags】                          | 修改kubeconfig文件                             |
| create       | kubectl create -f filename 【flags】                         | 通过配置文件创建资源                           |
| delete       | kubectl delete (-f filename \| type name \| -l label) 【flags】 | 通过从文件中，名称，标签删除资源               |
| describe     | kubectl describe (-f filename \| type name) 【flags】        | 显示资源的详细状态                             |
| diff         | kubectl diff -f filename 【flags】                           | beta版本                                       |
| edit         | kubectl edit (-f filename \| type name) 【flags】            | 使用默认服务器编辑或者更新一个或多个资源的定义 |
| exec         | kubectl exec pod 【-c container】 【-i】【-t】【flags】 【-- command 【args ...】】 | 对pod中的容器执行命令                          |
| explain      | kubectl explain 【--include-extended-apis=true】【--recursive=false】【flags】 | 获取各种资源的文档。                           |
| expose       | kubectl exposee (-f filename \| type name) 【--port=port】【--protocol=tcp/udp】【--target-port=number-or-name】【--name=name】【--external-ip=external-ip-of-service】【--type=type】【flags】 |                                                |
|              |                                                              |                                                |
|              |                                                              |                                                |
|              |                                                              |                                                |
|              |                                                              |                                                |

