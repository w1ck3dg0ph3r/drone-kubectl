# !/bin/sh

INIT_FILE=/.initfile
if [ ! -f $INIT_FILE ]; then
    echo "Initializing kubectl context..."
    /init.sh
    touch $INIT_FILE
fi

for arg in $@; do
  if echo "$arg" | grep -qE '\.ya?ml$'; then
    echo "Running variable substitutions on $arg..."
    cat $arg | envsubst > $arg.tmp
    mv $arg.tmp $arg
  fi
done

IFS=','
for file in $PLUGIN_SUBSTITUTE; do
  echo "Running variable substitutions on $file..."
  cat $file | envsubst > $file.tmp
  mv $file.tmp $file
done
unset IFS

echo "Running 'kubectl $@'..."
/opt/bin/kubectl $@
