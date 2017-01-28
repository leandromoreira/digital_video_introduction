EXITED=$(docker ps -q -f status=exited)
DANGLING=$(docker images -q -f "dangling=true")
DANGLING_VOLUME=$(docker volume ls -qf "dangling=true")

if [ "$1" == "--dry-run" ]; then
  echo "==> Would stop containers:"
  echo $EXITED
  echo "==> And images:"
  echo $DANGLING
else
  if [ -n "$EXITED" ]; then
    docker rm $EXITED
  else
    echo "No containers to remove."
  fi
  if [ -n "$DANGLING" ]; then
    docker rmi $DANGLING
  else
    echo "No images to remove."
  fi
  if [ -n "$DANGLING_VOLUME" ]; then
    docker volume rm $DANGLING_VOLUME
  else
    echo "No volumes to remove."
  fi
fi
