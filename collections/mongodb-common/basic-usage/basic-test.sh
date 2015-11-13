#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

MONGODB_DATABASE=testdb
MONGODB_USER=testuser
MONGODB_PASSWORD=testpass
MONGODB_ADMIN_PASSWORD=adminpass

source scl_source enable $ENABLE_SCLS

set -xe

service $SERVICE_NAME restart

mongo ${MONGODB_DATABASE} --eval "db.removeUser('${MONGODB_USER}')"
mongo admin --eval "db.removeUser('admin')"
mongo ${MONGODB_DATABASE} --eval "db.addUser({user: '${MONGODB_USER}', pwd: '${MONGODB_PASSWORD}', roles: [ 'readWrite' ]})"
mongo admin --eval "db.addUser({user: 'admin', pwd: '${MONGODB_ADMIN_PASSWORD}', roles: ['dbAdminAnyDatabase', 'userAdminAnyDatabase' , 'readWriteAnyDatabase','clusterAdmin' ]})"

mongo "$MONGODB_DATABASE" --host 127.0.0.1 -u "$MONGODB_USER" -p "$MONGODB_PASSWORD" <<'EOF'
db.restaurants.insert(
   {
      "address" : {
         "street" : "2 Avenue",
         "zipcode" : "10075",
         "building" : "1480",
         "coord" : [ -73.9557413, 40.7720266 ],
      },
      "borough" : "Manhattan",
      "cuisine" : "Italian",
      "grades" : [
         {
            "date" : ISODate("2014-10-01T00:00:00Z"),
            "grade" : "A",
            "score" : 11
         },
         {
            "date" : ISODate("2014-01-16T00:00:00Z"),
            "grade" : "B",
            "score" : 17
         }
      ],
      "name" : "Vella",
      "restaurant_id" : "41704620"
   }
)
EOF

out=$(
mongo "$MONGODB_DATABASE" --quiet --host 127.0.0.1 -u "$MONGODB_USER" -p "$MONGODB_PASSWORD" <<'EOF'
f = db.restaurants.findOne( { "address.zipcode": "10075" } ).borough
//f.borough
EOF
)

[ "$out" == "Manhattan" ]

