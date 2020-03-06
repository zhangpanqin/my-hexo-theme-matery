BASE_DIR=$(
    cd $(dirname $0)
    pwd
)
# 进入项目路径下
cd ${BASE_DIR}

yarn run build
hexo d
if [ $? != 0 ]; then
    echo "构建失败,退出"
    exit -1
fi

# 拷贝项目路径下 themes/matery/source  到 oss 上去

/Users/zhangpanqin/app/oss/ossutilmac64 cp -rf ${BASE_DIR}/themes/matery/source oss://bukect --meta=Cache-Control:public,max-age=2592000

if [ $? != 0 ]; then
    echo "上传 oss 失败,退出"
    exit -1
fi

public=${BASE_DIR}/public

if [ -d ${public} ]; then
    scp -rp ${public}/* mflyyou@47.104.168.20:/usr/share/nginx/html/
    echo "部署成功"
else
    echo "${public} 不存在,部署失败"
fi
