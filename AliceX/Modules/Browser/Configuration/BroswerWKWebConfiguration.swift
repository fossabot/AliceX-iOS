//
//  BroswerWKWebConfiguration.swift
//  AliceX
//
//  Created by lmcmz on 12/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import web3swift

extension WKWebViewConfiguration {
    static func make(forServer server: Web3NetEnum, address: String, in messageHandler: WKScriptMessageHandler) -> WKWebViewConfiguration {
        let webViewConfig = WKWebViewConfiguration()
        var js = ""

        guard let bundlePath = Bundle.main.path(forResource: "web3-min", ofType: "js") else {
            HUDManager.shared.showError(text: "Initial WebView Failure")
            return WKWebViewConfiguration()
        }

        js += try! String(contentsOfFile: bundlePath)

        let addressCheckSum = EthereumAddress.toChecksumAddress(address)

        js +=
            """
            const addressHex = "\(address)"
            const rpcURL = "\(server.rpcURL.absoluteString)"
            const chainID = "\(server.chainID)"
            
            function executeCallback (id, error, value) {
            Alice.executeCallback(id, error, value)
            }
            
            Alice.init(rpcURL, {
            getAccounts: function (cb) { alert('hello'); cb(null, [addressHex]) },
            processTransaction: function (tx, cb){
                console.log('signing a transaction', tx)
                const { id = 8888 } = tx
                Alice.addCallback(id, cb)
                webkit.messageHandlers.signTransaction.postMessage({"name": "signTransaction", "object": tx, id: id})
            },
            signMessage: function (msgParams, cb) {
                const { data } = msgParams
                const { id = 8888 } = msgParams
                console.log("signing a message", msgParams)
                Alice.addCallback(id, cb)
                webkit.messageHandlers.signMessage.postMessage({"name": "signMessage", "object": { data }, id: id})
            },
            signPersonalMessage: function (msgParams, cb) {
                const { data } = msgParams
                const { id = 8888 } = msgParams
                console.log("signing a personal message", msgParams)
                Alice.addCallback(id, cb)
                webkit.messageHandlers.signPersonalMessage.postMessage({"name": "signPersonalMessage", "object": { data }, id: id})
            },
            signTypedMessage: function (msgParams, cb) {
                const { data } = msgParams
                const { id = 8888 } = msgParams
                console.log("signing a typed message", msgParams)
                Alice.addCallback(id, cb)
                webkit.messageHandlers.signTypedMessage.postMessage({"name": "signTypedMessage", "object": { data }, id: id})
            },
            enable: function() {
            return new Promise(function(resolve, reject) {
            //send back the coinbase account as an array of one
            resolve([addressHex])
            })
            }
            }, {
            address: addressHex,
            networkVersion: chainID
            })
            
            web3.setProvider = function () {
            console.debug('Alice - overrode web3.setProvider')
            }
            
            web3.eth.defaultAccount = addressHex
            
            web3.version.getNetwork = function(cb) {
            cb(null, chainID)
            }
            
            web3.eth.getCoinbase = function(cb) {
            return cb(null, addressHex)
            }
            
            window.ethereum = web3.currentProvider
            """

        let userScript = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        webViewConfig.userContentController.add(messageHandler, name: BrowserMethod.signTransaction.rawValue)
        webViewConfig.userContentController.add(messageHandler, name: BrowserMethod.signPersonalMessage.rawValue)
        webViewConfig.userContentController.add(messageHandler, name: BrowserMethod.signMessage.rawValue)
        webViewConfig.userContentController.add(messageHandler, name: BrowserMethod.signTypedMessage.rawValue)
        webViewConfig.userContentController.addUserScript(userScript)
        return webViewConfig
    }
}
