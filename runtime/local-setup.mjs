import { SQLiteDatabaseClient } from "@abaplint/database-sqlite";
import { zusers } from "./fixtures/zusers.mjs";
import { dd04l } from "./fixtures/dd04l.mjs";
import { spfli } from "./fixtures/spfli.mjs";
import { sflight } from "./fixtures/sflight.mjs";
import { scarr } from "./fixtures/scarr.mjs";
import { t005t } from "./fixtures/t005t.mjs";
import { t006a } from "./fixtures/t006a.mjs";
import { icon } from "./fixtures/icon.mjs";

function escapeSqlText(value) {
    if (!value) return '';
    if (typeof value !== 'string') return String(value).replaceAll("'", "''");
    return value.replaceAll("'", "''");
}

export async function initializeLocalRuntime(abap, schemas) {
    let sqlite = schemas.sqlite.join(" ");
    
    // Add missing tables manually if not present
    if (!sqlite.includes("CREATE TABLE 'spfli'")) {
        sqlite += "CREATE TABLE 'spfli' ('carrid' NCHAR(10) COLLATE RTRIM, 'countryfr' NCHAR(10) COLLATE RTRIM, 'countryto' NCHAR(10) COLLATE RTRIM, 'cityto' NCHAR(10) COLLATE RTRIM, 'connid' NCHAR(10) COLLATE RTRIM, 'deptime' NCHAR(10) COLLATE RTRIM, 'arrtime' NCHAR(10) COLLATE RTRIM, 'cityfrom' NCHAR(10) COLLATE RTRIM); ";
    }
    if (!sqlite.includes("CREATE TABLE 'sflight'")) {
        sqlite += "CREATE TABLE 'sflight' ('carrid' NCHAR(10) COLLATE RTRIM, 'connid' NCHAR(10) COLLATE RTRIM, 'fldate' NCHAR(10) COLLATE RTRIM, 'price' INT, 'currency' NCHAR(10) COLLATE RTRIM, 'seatsmax' INT, 'seatsocc' INT, 'paymentsum' INT); ";
    }
    if (!sqlite.includes("CREATE TABLE 'scarr'")) {
        sqlite += "CREATE TABLE 'scarr' ('carrid' NCHAR(3) COLLATE RTRIM, 'carrname' NCHAR(20) COLLATE RTRIM); ";
    }
    if (!sqlite.includes("CREATE TABLE 't005t'")) {
        sqlite += "CREATE TABLE 't005t' ('spras' NCHAR(1) COLLATE RTRIM, 'land1' NCHAR(3) COLLATE RTRIM, 'landx' NCHAR(15) COLLATE RTRIM, 'landx50' NCHAR(50) COLLATE RTRIM); ";
    }
    if (!sqlite.includes("CREATE TABLE 't006a'")) {
        sqlite += "CREATE TABLE 't006a' ('spras' NCHAR(1) COLLATE RTRIM, 'msehi' NCHAR(3) COLLATE RTRIM, 'msehl' NCHAR(30) COLLATE RTRIM); ";
    }
    if (!sqlite.includes("CREATE TABLE 'icon'")) {
        sqlite += "CREATE TABLE 'icon' ('id' NCHAR(4) COLLATE RTRIM, 'name' NCHAR(30) COLLATE RTRIM, 'oleng' INT, 's_raw' TEXT); ";
    }
    if (!sqlite.includes("CREATE TABLE 'wwwparams'")) {
        sqlite += "CREATE TABLE 'wwwparams' ('relid' NCHAR(2) COLLATE RTRIM, 'objid' NCHAR(40) COLLATE RTRIM, 'name' NCHAR(50) COLLATE RTRIM, 'value' NCHAR(250) COLLATE RTRIM); ";
    }

    const database = new SQLiteDatabaseClient();
    abap.context.databaseConnections.DEFAULT = database;

    await database.connect();
    await database.execute(sqlite);

    for (const user of zusers) {
        await database.execute(
            `INSERT INTO zusers (id, name) VALUES (${user.id}, '${escapeSqlText(user.name)}')`,
        );
    }

    for (const item of dd04l) {
        await database.execute(
            `INSERT INTO dd04l (rollname, as4local, as4vers, domname) VALUES ('${escapeSqlText(item.rollname)}', '${escapeSqlText(item.as4local)}', '${escapeSqlText(item.as4vers)}', '${escapeSqlText(item.domname)}')`,
        );
    }

    for (const row of spfli) {
        await database.execute(
            "INSERT INTO spfli (carrid, connid, countryfr, cityfrom, countryto, cityto, deptime, arrtime) VALUES ('" + escapeSqlText(row.carrid) + "', '" + escapeSqlText(row.connid) + "', '" + escapeSqlText(row.countryfr) + "', '" + escapeSqlText(row.cityfrom) + "', '" + escapeSqlText(row.countryto) + "', '" + escapeSqlText(row.cityto) + "', '" + escapeSqlText(row.deptime) + "', '" + escapeSqlText(row.arrtime) + "')"
        );
    }

    for (const row of sflight) {
        await database.execute(
            "INSERT INTO sflight (carrid, connid, fldate, price, currency, seatsmax, seatsocc) VALUES ('" + escapeSqlText(row.carrid) + "', '" + escapeSqlText(row.connid) + "', '" + escapeSqlText(row.fldate) + "', " + row.price + ", '" + escapeSqlText(row.currency) + "', " + row.seatsmax + ", " + row.seatsocc + ")"
        );
    }

    for (const row of scarr) {
        await database.execute(
            "INSERT INTO scarr (carrid, carrname) VALUES ('" + escapeSqlText(row.carrid) + "', '" + escapeSqlText(row.carrname) + "')"
        );
    }

    for (const row of t005t) {
        await database.execute(
            "INSERT INTO t005t (spras, land1, landx, landx50) VALUES ('" + escapeSqlText(row.spras) + "', '" + escapeSqlText(row.land1) + "', '" + escapeSqlText(row.landx) + "', '" + escapeSqlText(row.landx50) + "')"
        );
    }

    for (const row of t006a) {
        await database.execute(
            "INSERT INTO t006a (spras, msehi, msehl) VALUES ('" + escapeSqlText(row.spras) + "', '" + escapeSqlText(row.msehi) + "', '" + escapeSqlText(row.msehl) + "')"
        );
    }

    for (const row of icon) {
        await database.execute(
            "INSERT INTO icon (id, name, oleng, s_raw) VALUES ('" + escapeSqlText(row.id) + "', '" + escapeSqlText(row.name) + "', " + row.oleng + ", '" + escapeSqlText(row.s_raw) + "')"
        );
    }
}