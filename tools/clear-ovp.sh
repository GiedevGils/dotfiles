CONTEXT=$(docker context show)

if [ "$CONTEXT" != "default" ]; then
	echo "Docker context not default. Not executing clear command"
	exit 1
fi

read -p "This will delete the bijlage-api databases. It'll clear all but the counters from the opdrachtverstrekking db. It'll also clear the testtool of messages, opdrachten, and leveringen. Continue? (y/n) " choice

case "$choice" in
	y|Y ) echo "Clearing databases"; \
				echo Opdrachtverstrekking; \
				mongosh opdrachtverstrekking --eval 'db.opdracht.drop(); db.message.drop(); db.opdrachthoofdnet.drop(); db.levering.drop(); db.placeholder_opdracht.drop();' --quiet; \
				echo Bijlagen; \
	     	mongosh bijlage --eval 'db.bijlage.drop()' --quiet; \
				echo Testtool; \
			 	mongosh testtool --eval 'db.message.drop(); db.opdracht.drop(); db.levering.drop()' --quiet;;
	* ) echo "no action taken"; exit 0;;
esac
