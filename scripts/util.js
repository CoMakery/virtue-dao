window.util = {}

window.util.getABI = async function getABI(path) {
    let rawResponse = await fetch(path).then(async (response) => {
        return await response.json()
    })
    return rawResponse["abi"];
}

window.util.pollForCompletion = function pollForCompletion(txHash, callback) {
    let calledBack = false
    const checkInterval = setInterval(function () {
        const notYet = 'response has no error or result'
        ethereum.sendAsync({
            method: 'eth_getTransactionByHash',
            params: [txHash],
        }, function (err, response) {
            if (calledBack) return
            if (err || response.error) {
                if (err.message.includes(notYet)) {
                    return 'transactiion is not yet mined'
                }

                callback(err || response.error)
            }

            const transaction = response.result
            clearInterval(checkInterval)
            calledBack = true
            callback(null, transaction)
        })
    }, 2000)
}