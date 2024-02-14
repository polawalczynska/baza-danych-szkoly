import axios from "axios";

const SIZE_OF_GRID = 800;

export const getColums = (data: any) => {
    const objectWithAllKeys = data
        .map((data: any) => {
            return Object.keys(data)
        })
        .reduce(
            (left: any, right: any) => {
                return {
                    ...left,
                    ...right
                }
            },
            {}
        )
    const amountOfKeys = Object.keys(objectWithAllKeys).length
    return Object.keys(objectWithAllKeys)
        .map(key => {
            return {
                field: objectWithAllKeys[key],
                headerName: objectWithAllKeys[key],
                width: SIZE_OF_GRID / amountOfKeys,
            }
        }
        )
}

export const addIdIfNotExists = (objects: any) => {
    var i = 0;
    return objects.map((current: any) => {
        if (!current.hasOwnProperty('id')) {
            current.id = i + '_'
        }
        i = i + 1;
        return current;
    })
}

export const generateFunctionPath = (functions: any[], functionName: string, functionType: string) => {
    const functionParameters = functions.filter(
        fun => fun['routine_name'] == functionName && fun['parameter_mode'] != "RETURN"
    );
    var result = functionType + "," + functionName + ",";
    functionParameters.map(fun => fun['DATA_TYPE']).forEach(dataType => {
        result += dataType == "tinyint" ? "bool" : dataType + ","
    })
    return result
}

export const fetchData = (url: string, setData: (data: any) => void, onFetched: () => void) => {
    axios
        .get('http://34.125.149.136/' + url)
        .then((res) => {
            setData(res.data);
            onFetched();
        })
        .catch((err) => {
            console.log(err);
            onFetched();
        });
}
