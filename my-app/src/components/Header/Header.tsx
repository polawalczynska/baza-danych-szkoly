import {
    AppBar,
    Toolbar,
    Typography,
    makeStyles,
    Button,
} from "@material-ui/core";
import React from "react";
import { Link } from "react-router-dom";

const headersData = [
    { label: "Home", href: "/" },
    { label: "Menu", href: "/menu" },
    { label: "Students", href: "/select/students" },
    { label: "Teachers", href: "/select/teachers" },
    { label: "Subjects", href: "/select/subjects" },
    { label: "Lessons", href: "/select/lessons" },
];

const useStyles = makeStyles(() => ({
    blankSpace: {
        height: 64,
    },
    header: {
        backgroundImage: "linear-gradient(to right, rgb(77 68 55), rgb(0 0 0))",
    },
    logo: {
        fontFamily: "Work Sans, sans-serif",
        fontWeight: 600,
        color: "#FFFEFE",
        textAlign: "left",
    },
    menuButton: {
        fontFamily: "Open Sans, sans-serif",
        fontWeight: 700,
        size: "18px",
        marginLeft: "38px",
    },
    toolbar: {
        display: "flex",
        justifyContent: "space-between",
    },
}));

const Header = () => {
    const { header, logo, toolbar, menuButton, blankSpace } = useStyles();

    const femmecubatorLogo = (
        <Typography variant="h6" component="h2" className={logo}>
            Infa 3 sem bazy danych
        </Typography>
    );


    return (
        <header>
            <AppBar className={header}>
                <Toolbar className={toolbar}>
                    {femmecubatorLogo}
                    {headersData.map(({ label, href }) =>
                        <Button className={menuButton}
                            key={label}
                            color={"inherit"}
                            to={href}
                            component={Link}
                        >
                            {label}
                        </Button>
                    )}
                </Toolbar>
            </AppBar>
            <div className={blankSpace} />
        </header>
    );
}

export default Header;
