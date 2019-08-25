window.util = {}

window.util.getABI = async function getABI(path) {
    let rawResponse = await fetch(path).then(async (response) => {
        return await response.json()
    })
    return rawResponse["abi"];
}