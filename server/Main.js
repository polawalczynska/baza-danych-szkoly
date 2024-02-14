const express = require('express');
const app = express();
const path = require('path')
const fs = require('fs');
const {createPool} = require('mysql2')
const cors = require('cors')

app.use(cors())

const SERVER_LATENCY = 200;

const pool = createPool({
        host: "localhost",
        user: "root",
        password: "userRoot"
    }
)

const getFunctionMenuSql = () => {
    try {
        return fs.readFileSync('./functionMenu.sql', {encoding: 'utf8'});
    } catch (err) {
        console.error("ERROR");
        console.error(err);
        return "";
    }
}

const getPossibleFunctions = () => {
    return new Promise((resolve) => {
        pool.query(getFunctionMenuSql(), (err, res) => {
            resolve(res);
        });
    });
}

const getPossibleViews = () => {
    return new Promise((resolve) => {
        pool.query("SHOW FULL TABLES IN sql_uj_3sem WHERE TABLE_TYPE LIKE 'VIEW';", (err, res) => {
            resolve(res);
        });
    });
}

const getPossibleDatabases = () => {
    return new Promise((resolve) => {
        pool.query("SHOW FULL TABLES IN  sql_uj_3sem WHERE TABLE_TYPE != 'VIEW';", (err, res) => {
            resolve(res);
        });
    });
}

const runFunction = (fooType, fooName, arg1, arg2, arg3, arg4, arg5) => {
    return new Promise((resolve) => {
        var query = `select sql_uj_3sem.${fooName}(`;
        if (fooType === "PROCEDURE") query = `call sql_uj_3sem.${fooName}(`;

        if (arg1) {
            query += arg1;
        }
        if (arg2) {
            query += ',' + arg2;
        }
        if (arg3) {
            query += ',' + arg3;
        }
        if (arg4) {
            query += ',' + arg4;
        }
        if (arg5) {
            query += ',' + arg5;
        }
        query += ");"
        console.log(query)
        pool.query(query, (err, res) => {
            if (fooType === "PROCEDURE")
                resolve(res[0]);
            else
                resolve(res);
        });
    });
}


const getTable = (tableTame) => {
    return new Promise((resolve) => { // students; DROP TABLE STUDENTS
        const query = " select * from sql_uj_3sem." + tableTame;
        console.log(tableTame)
        console.log(query)
        pool.query(query, (err, res) => {
            resolve(res);
        });
    });
}

app.use(express.static(path.join(__dirname, 'build')));

app.get('/files/README', async (req, res) => {
    await new Promise(resolve => setTimeout(resolve, SERVER_LATENCY));
    res.sendFile(path.join(__dirname, 'public', 'README.md'))
});

app.get('/api/menuTables', async (req, res) => {
    await new Promise(resolve => setTimeout(resolve, SERVER_LATENCY));

    const result = await getPossibleDatabases();

    console.log(result)
    res.end(JSON.stringify(result))
});

app.get('/api/menuFunctions', async (req, res) => {
    await new Promise(resolve => setTimeout(resolve, SERVER_LATENCY));

    const result = await getPossibleFunctions();

    console.log(result)
    res.end(JSON.stringify(result))
});

app.get('/api/menuViews', async (req, res) => {
    await new Promise(resolve => setTimeout(resolve, SERVER_LATENCY));

    const result = await getPossibleViews();

    console.log(result)
    res.end(JSON.stringify(result))
});

app.get('/api/select/', async (req, res) => {
    await new Promise(resolve => setTimeout(resolve, SERVER_LATENCY));

    let databaseName = req.query.databaseName;

    const result = await getTable(databaseName);

    console.log(result)
    res.end(JSON.stringify(result))
});


app.get('/api/run/', async (req, res) => {
    await new Promise(resolve => setTimeout(resolve, SERVER_LATENCY));

    let fooType = req.query.type;
    let fooName = req.query.name;
    let arg1 = req.query.arg1;
    let arg2 = req.query.arg2;
    let arg3 = req.query.arg3;
    let arg4 = req.query.arg4;
    let arg5 = req.query.arg5;
    console.log(fooType, fooName)
    const result = await runFunction(fooType, fooName, arg1, arg2, arg3, arg4, arg5);

    console.log(result)
    res.end(JSON.stringify(result))
});

app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'build', 'index.html'))
});

app.listen(3000);
