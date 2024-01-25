CONTEXT=$(docker context show)

if [ "$CONTEXT" != "default" ]; then
	echo "Docker context not default. Not executing clear command"
	exit 1
fi

read -p "This will delete the ovp & bijlage-api databases. it'll also clear the testtool of messages and opdrachten. Continue? (y/n) " choice

case "$choice" in
	y|Y ) mongosh opdrachtverstrekking --eval 'db.dropDatabase()' --quiet; mongosh bijlage --eval 'db.dropDatabase()' --quiet; mongosh testtool --eval 'db.message.deleteMany({}); db.opdracht.deleteMany({});' --quiet;;
	* ) echo "no action taken"; exit 0;;
esac

