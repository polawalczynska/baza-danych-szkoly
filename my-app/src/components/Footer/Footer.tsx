import {
    AppBar,
    Toolbar,
    Typography,
    makeStyles,
    Button,
} from "@material-ui/core";
import React from "react";
import { Link } from "react-router-dom";

const useStyles = makeStyles(() => ({
    blankSpace: {
        marginTop: 16,
        height: 64,
        backgroundColor: "black"
    },
}));

const Footer = () => {
    const { blankSpace } = useStyles();

    return (
        <footer>
            <div className={blankSpace} />
        </footer>
    );
}

export default Footer;
