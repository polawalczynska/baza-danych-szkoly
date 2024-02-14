import { ReactElement } from "react";
import { makeStyles } from "@material-ui/core";
import Loader from "../Loder/Loader";

type Props = {
    children: ReactElement,
    isLoading: boolean
}

const useStyles = makeStyles(() => ({
    mainContainer: {
        maxWidth: 700,
        margin: 'auto',
        minHeight: 'calc(100vh - 64px)',
        backgroundImage: "linear-gradient(to right, rgb(255 241 237 / 90%), rgb(252 245 227))",
        padding: 20,
        overflow: 'scroll'
    },
}));

const Boody = ({ children, isLoading }: Props) => {
    const { mainContainer } = useStyles();

    return <>
        {isLoading ? <Loader /> : null}
        <div className={mainContainer}>
            {children}
        </div>
    </>
}

export default Boody;
