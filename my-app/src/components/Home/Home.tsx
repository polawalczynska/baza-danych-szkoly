import React, { useEffect, useState } from "react";
import { fetchData } from "../../common/utils/Utils";
import { makeStyles, Typography } from "@material-ui/core";
import ReactMarkdown from "react-markdown";

type Props = {
    setLoading: (value: boolean) => void;
}

const Home = ({ setLoading }: Props) => {
    const [data, setData] = useState(null);
    const { header } = useStyles();

    useEffect(() => {
        setLoading(true);
        fetchData('files/README', setData, () => setLoading(false));
    }, [])

    if (!data) return <></>;

    return <div>
        <Typography variant="h4" component="h2" className={header}>
            Project description
        </Typography>
        <ReactMarkdown>{data}</ReactMarkdown>
    </div>
}

const useStyles = makeStyles({
    header: {
        margin: 20,
    }
})
export default Home;
