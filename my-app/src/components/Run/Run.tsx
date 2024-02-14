import {useParams} from "react-router-dom";
import React, {useEffect, useRef, useState} from "react";
import {DataGrid} from '@mui/x-data-grid'
import {getColums, fetchData, addIdIfNotExists} from "../../common/utils/Utils";
import {Box, TextField} from "@mui/material";
import {Button, makeStyles, Typography} from "@material-ui/core";

type UrlProps = {
    fooParams: string
}

type Props = {
    setLoading: (value: boolean) => void;
}

const parse = (fooParams: string | undefined) => {
    if (!fooParams) fooParams = "notfound,";
    const splited = fooParams.split(",")
    return {
        fooName: splited[1],
        fooType: splited[0],
        arg1: splited[2],
        arg2: splited[3],
        arg3: splited[4],
        arg4: splited[5],
        arg5: splited[6]
    }
}

const getDefaultFor = (type: string) => {
    if (type == "int") {
        return 2;
    }
    if (type == "bool") {
        return 1;
    }
    if (type == "date") {
        return "2012-12-2";
    }
    return 0;
}

const getArg = (type: string, ref: any) => {
    if (type == "date") {
        return "'" + ref.current.value + "'"
    }
    if (type == "varchar") {
        return "'" + ref.current.value + "'"
    }
    return ref.current.value;
}

const Run = ({setLoading}: Props) => {
    const {fooName, fooType,arg1, arg2, arg3, arg4, arg5} = parse(useParams<UrlProps>().fooParams);
    const arg1Ref = useRef({value: ''});
    const arg2Ref = useRef({value: ''});
    const arg3Ref = useRef({value: ''});
    const arg4Ref = useRef({value: ''});
    const arg5Ref = useRef({value: ''});

    const [data, setData] = useState(null);
    const {header} = useStyles();
    useEffect(() => {
        setLoading(false);
        setTimeout(() => {
            window.scrollTo({left: 0, top: 0, behavior: 'smooth'})
        }, 300)
    }, []);

    useStyles();

    const fetch = () => {
        setLoading(true);
        fetchData(`api/run/?type=${fooType}&name=${fooName}&arg1=${getArg(arg1, arg1Ref)}&arg2=${getArg(arg2, arg2Ref)}&arg3=${getArg(arg3, arg3Ref)}&arg4=${getArg(arg4, arg4Ref)}&arg5=${getArg(arg5, arg5Ref)}`,
            setData,
            () => setLoading(false));
    }

    return <div>
        <Typography variant="h4" component="h2" className={header}>
            Run function {fooName}
        </Typography>
        {arg1 ?
            <TextField inputRef={arg1Ref} id="outlined-basic" defaultValue={getDefaultFor(arg1)} label={arg1}
                       variant="outlined"/> : null}
        {arg2 ?
            <TextField inputRef={arg2Ref} id="outlined-basic" defaultValue={getDefaultFor(arg2)} label={arg2}
                       variant="outlined"/> : null}
        {arg3 ?
            <TextField inputRef={arg3Ref} id="outlined-basic" defaultValue={getDefaultFor(arg3)} label={arg3}
                       variant="outlined"/> : null}
        {arg4 ?
            <TextField inputRef={arg4Ref} id="outlined-basic" defaultValue={getDefaultFor(arg4)} label={arg4}
                       variant="outlined"/> : null}
        {arg5 ?
            <TextField inputRef={arg5Ref} id="outlined-basic" defaultValue={getDefaultFor(arg5)} label={arg5}
                       variant="outlined"/> : null}
        <Button
            onClick={fetch}>
            Run
        </Button>

        {data ? <Box sx={{height: 400, width: '100%'}}>
            <DataGrid
                rows={addIdIfNotExists(data)}
                columns={getColums(addIdIfNotExists(data))}
                pageSize={10}
                rowsPerPageOptions={[10]}
            />
        </Box> : null}
    </div>
}

const useStyles = makeStyles({
    header: {
        margin: 20,
    }
})
export default Run;
