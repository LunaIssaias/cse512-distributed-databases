const sdb  = db.getSiblingDB('demoDB');
const coll = sdb.getCollection('repl_demo');

// 1) INSERT with writeConcern: "majority"
const doc = { _id: new ObjectId(), ts: new Date(), note: 'replication demo', rand: Math.random() };
print('\n[1] Inserting document with writeConcern: majority ...');
const insertRes = coll.insertOne(doc, { writeConcern: { w: 'majority' } });
print('Insert result:', tojson(insertRes));
print('Inserted _id:', doc._id);

// 2) READ from a SECONDARY node
print('\n[2] Setting readPreference to SECONDARY and reading the document ...');
db.getMongo().setReadPref('secondary');
const fromSecondary = coll.find({ _id: doc._id }).limit(1).toArray();
print('Read from secondary:', tojson(fromSecondary));

// 3) READ with readConcern: "majority" (via a session)
print('\n[3] Starting session with readConcern: "majority" and reading the document ...');
const session = db.getMongo().startSession({ readConcern: { level: 'majority' } });
const sdbSess  = session.getDatabase('demoDB');
const collSess = sdbSess.getCollection('repl_demo');
const fromMajority = collSess.find({ _id: doc._id }).limit(1).toArray();
print('Read with majority readConcern (session):', tojson(fromMajority));
session.endSession();

// 4) Restore read preference to PRIMARY
print('\n[4] Restoring readPreference to PRIMARY ...');
db.getMongo().setReadPref('primary');
print('ReadPreference reset to PRIMARY.');
