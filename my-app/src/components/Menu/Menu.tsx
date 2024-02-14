import React, { useEffect, useState } from "react";
import { fetchData, generateFunctionPath } from "../../common/utils/Utils";
import { Button, makeStyles, Typography } from "@material-ui/core";
import { Divider } from "@mui/material";
import TableRowsIcon from '@mui/icons-material/TableRows';
import { Link } from "react-router-dom";
import DisplaySettingsIcon from '@mui/icons-material/DisplaySettings';
import PlayCircleFilledIcon from '@mui/icons-material/PlayCircleFilled';

type Props = {
    setLoading: (value: boolean) => void;
}

const createListOfTables = (tables: any, button: any) => {
    if (!tables) return null;
    return tables
        .map((tableObject: any) => tableObject['Tables_in_sql_uj_3sem'])
        .map((tableName: string) => {
            return <div key={tableName}>
                <Button className={button}
                    color={"inherit"}
                    to={"/select/" + tableName}
                    component={Link}
                >
                    <TableRowsIcon />
                    {tableName}
                </Button>
            </div>;
        }
        );
}

const createListOfFunctions = (functions: any, button: any) => {
    if (!functions) return null;

    const namesAndTypes = new Map<string, string>()
    functions
        .forEach((tableObject: any) => {
            namesAndTypes.set(tableObject['routine_name'], tableObject['type'])
        });
    const buttons: any[] = []
    console.log(namesAndTypes)
    namesAndTypes.forEach((key, value) => {
        buttons.push(
            <div key={value}>
                <Button className={button} color={"inherit"}
                    to={"/run/" + generateFunctionPath(functions, value, key)}
                    component={Link}
                >
                    {key == "PROCEDURE" ? <DisplaySettingsIcon /> : <PlayCircleFilledIcon />}
                    {value}
                    <div style={{ fontSize: 7, marginTop: 5 }}>{key}</div>
                </Button>
            </div>
        );
    }
    );
    return buttons;
}

const createListOfViews = (views: any, button: any) => {
    if (!views) return null;
    return views
        .map((tableObject: any) => tableObject['Tables_in_sql_uj_3sem'])
        .map((tableName: string) => {
            return <div key={tableName}>
                <Button className={button}
                    color={"inherit"}
                    to={"/select/" + tableName}
                    component={Link}
                >
                    <TableRowsIcon />
                    {tableName}
                </Button>
            </div>;
        }
        );
}
const Menu = ({ setLoading }: Props) => {
    const [tables, setTableNames] = useState(null);
    const [functions, setFunctions] = useState(null);
    const [views, setViews] = useState(null);

    const { header, button, subHeader } = useStyles();

    useEffect(() => {
        setLoading(true);
        fetchData('api/menuTables', setTableNames,
            () => fetchData('api/menuFunctions', setFunctions,
                () => fetchData('api/menuViews', setViews, () => setLoading(false)
                )));
    }, [])

    return <div>
        <Typography variant="h3" component="h2" className={header}>
            Available functionality
        </Typography>
        <Divider />
        <Typography variant="h4" component="h2" className={subHeader}>
            Tables
        </Typography>
        {createListOfTables(tables, button)}
        <Divider />
        <Typography variant="h4" component="h2" className={subHeader}>
            Functions and procedures
        </Typography>
        {createListOfFunctions(functions, button)}
        <Divider />
        <Typography variant="h4" component="h2" className={subHeader}>
            Views
        </Typography>
        {createListOfViews(views, button)}
        <Divider />
    </div>
}

const useStyles = makeStyles(
    {
        header: {
            margin: 20,
        },
        subHeader: {
            marginLeft: 30,
        },
        button: {
            marginLeft: 35,
        }

    }
)
export default Menu;
