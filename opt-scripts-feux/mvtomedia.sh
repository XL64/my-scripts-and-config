if [ ! $# -eq 2 ] 
then
  echo "Usage: $0 <source> <destination>."
  echo "  Move source to destination and create the link to replace it."
  exit
fi  

mkdir -p $(dirname $2)
mv $1 $2
ln -fs $2/$(basename $1) $(dirname $1)