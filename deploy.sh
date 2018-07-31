#!/bin/sh
set -e
args=`getopt e: $*`
tag=`date +%Y%m%d%H%M%S`
for opt do
  case "$opt" in
    -e)
      env=$2; shift; shift;;
    --)
      shift; break;;
  esac
done
if [ "$format" = "" ]; then
  format="web"
fi
case "$env" in
  production)
    image_prefix="production-${service}-${format}-"
    update_latest="1"
    ;;
  staging)
    image_prefix="staging-${service}-${format}-"
    update_latest="1"
    ;;
  sandbox)
    image_prefix="sandbox-${service}-${format}-"
    update_latest="1"
    ;;
  *)
    image_prefix="${env}-${service}-${format}-"
    update_latest="0"
esac
current_branch=`git rev-parse --abbrev-ref HEAD`
if [ "$env" = "production" -a "$current_branch" != "master" ]; then
  echo "Cannot deploy no master branch to production enviroment." >&2
  exit 1
fi
image_name=${CONTAINER_REGISTORY}/spacemarket/frontend
docker build \
  --build-arg precompile=production \
  --build-arg AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  --build-arg AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  --build-arg AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
  -t frontend .
`aws --profile ecs-deploy-user ecr get-login --no-include-email --region ap-northeast-1 --no-include-email`
docker tag frontend $image_name:${image_prefix}$tag
docker push $image_name:${image_prefix}$tag
if [ "$update_latest" = "1" ]; then
  docker tag frontend $image_name:${image_prefix}latest
  docker push $image_name:${image_prefix}latest
fi
ecs-deploy \
  -c frontend-web-${env} \
  -n ${service}-${format} \
  -i $image_name:${image_prefix}$tag \
  -k $AWS_ACCESS_KEY_ID \
  -s $AWS_SECRET_ACCESS_KEY \
  -r $AWS_DEFAULT_REGION \
  -t 1000