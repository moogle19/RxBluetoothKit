// The MIT License (MIT)
//
// Copyright (c) 2016 Polidea
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import RxSwift
import RxCocoa
import CoreBluetooth

class RxCBCentralManagerDelegateProxy: DelegateProxy, CBCentralManagerDelegate, DelegateProxyType {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.forwardToDelegate()?.centralManagerDidUpdateState(central)
    }
    
    static var factory = DelegateProxyFactory { (parentObject: CBCentralManager) in
        RxCBCentralManagerDelegateProxy(parentObject: parentObject)
    }
    
    static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let centralManager = object as! CBCentralManager
        return centralManager.delegate
    }
    
    static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let centralManager = object as! CBCentralManager
        centralManager.delegate = delegate as? CBCentralManagerDelegate
    }
}

extension CBCentralManager: RxCentralManagerType {
    var objectId: UInt {
        return UInt(bitPattern: ObjectIdentifier(centralManager))
    }
    
    var rx_delegate: DelegateProxy {
        return DelegateProxy(parentObject: RxCBCentralManagerDelegateProxy.self)
    }
    
    var rx_didUpdateState: Observable<BluetoothState> {
        return rx_delegate.methodInvoked(#selector(CBCentralManagerDelegate.centralManagerDidUpdateState(_:)))
            .map({ a -> BluetoothState in
                return a[1] as! BluetoothState
            })
    }
    
    var rx_willRestoreState: Observable<[String : Any]> {
        return rx_delegate.methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:willRestoreState:)))
            .map({ a -> [String: Any] in
                return a[1] as! [String: Any]
            })
    }
    
    var rx_didDiscoverPeripheral: Observable<(RxPeripheralType, [String: Any], NSNumber)> {
        return rx_delegate.methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didDiscover:advertisementData:rssi:)))
            .map({ a -> (RxPeripheralType, [String: Any], NSNumber) in
                return (a[1], a[2], a[3]) as! (RxPeripheralType, [String: Any], NSNumber)
            })
    }
    
    var rx_didConnectPeripheral: Observable<RxPeripheralType> {
        return rx_delegate.methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didConnect:)))
            .map({ a -> RxPeripheralType in
                return a[1] as! RxPeripheralType
            })
    }
    
    var rx_didFailToConnectPeripheral: Observable<(RxPeripheralType, Error?)> {
        return rx_delegate.methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didFailToConnect:error:)))
            .map({ a -> (RxPeripheralType, Error?) in
                return (a[1], a[2]) as! (RxPeripheralType, Error?)
            })
    }
    
    var rx_didDisconnectPeripheral: Observable<(RxPeripheralType, Error?)> {
        return rx_delegate.methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didDisconnectPeripheral:error:)))
            .map({ a -> (RxPeripheralType, Error?) in
                return (a[1], a[2]) as! (RxPeripheralType, Error?)
            })
    }
    
//    var state: BluetoothState {
//        return self.
//        return rx_delegate.methodInvoked(#selector(
//    }
    
    var centralManager: CBCentralManager {
        return self
    }
    
    func connect(_ peripheral: RxPeripheralType, options: [String : Any]?) {
        self.connect(peripheral.peripheral, options: options)
    }
    
    func cancelPeripheralConnection(_ peripheral: RxPeripheralType) {
        self.cancelPeripheralConnection(peripheral.peripheral)
    }
    
    func retrieveConnectedPeripherals(withServices serviceUUIDs: [CBUUID]) -> Observable<[RxPeripheralType]> {
        return Observable<[RxPeripheralType]>.of(
            self.retrieveConnectedPeripherals(withServices: serviceUUIDs).map { $0 as! RxPeripheralType }
        )
    }
    
    func retrievePeripherals(withIdentifiers identifiers: [UUID]) -> Observable<[RxPeripheralType]> {
        return Observable<[RxPeripheralType]>.of(
            self.retrievePeripherals(withIdentifiers: identifiers).map { $0 as! RxPeripheralType }
        )
    }
    
    
}
