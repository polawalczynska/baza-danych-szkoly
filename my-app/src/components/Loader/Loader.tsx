import { CircularProgress } from "@mui/material";
import { makeStyles } from "@material-ui/core";


const useStyle = makeStyles({
    loading: {
        position: "absolute",
        left: "calc(50% - 50px)",
        top: "40%",
    },
    container: {
        background: "#faebd787",
        backdropFilter: "blur(10px)",
        width: "100%",
        height: "100%",
        position: "absolute",
        zIndex: 3,
    }
})
const Loader = () => {
    const { loading, container } = useStyle();
    return <div className={container}>
        <div className={loading}>
            <CircularProgress size={100} />
        </div>
    </div>
}

export default Loader;
