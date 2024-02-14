import {useParams} from "react-router-dom";
import React, {useEffect, useState} from "react";
import {DataGrid} from '@mui/x-data-grid'
import {getColums, fetchData, addIdIfNotExists} from "../../common/utils/Utils";
import {Box} from "@mui/material";
import {makeStyles, Typography} from "@material-ui/core";

type UrlProps = {
    databaseName: string
}

type Props = {
    setLoading: (value: boolean) => void;
}

const Select = ({setLoading}: Props) => {
    const {databaseName} = useParams<UrlProps>();
    const [data, setData] = useState(null);
    const {header} = useStyles();

    useEffect(() => {
        setLoading(true);
        fetchData('api/select/?databaseName=' + databaseName, setData,
            () => {
                setTimeout(() => {
                    window.scrollTo({left: 0, top: 0, behavior: 'smooth'})
                }, 300);
                setLoading(false)
            });

    }, [databaseName])

    if (!data) return <></>;

    return <div>
        <Typography variant="h4" component="h2" className={header}>
            Select from table {databaseName}
        </Typography>
        <Box sx={{height: '100vh', width: '100%'}}>
            <DataGrid
                rows={addIdIfNotExists(data)}
                columns={getColums(addIdIfNotExists(data))}
                pageSize={10}
                rowsPerPageOptions={[10]}
            />
        </Box>
    </div>
}

const useStyles = makeStyles({
    header: {
        margin: 20,
    }
})
export default Select;
