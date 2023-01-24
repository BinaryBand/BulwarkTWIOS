//
//  DFBlunoManager.m
//
//  Created by Seifer on 13-12-1.
//  Copyright (c) 2013年 DFRobot. All rights reserved.
//

#import "TWBlunoManager.h"

//#define kBlunoService @"49535343-FE7D-4AE5-8FA9-9FAFD205E455" //@"F000FFC0-0451-4000-B000-000000000000"//
//#define kBlunoDataCharacteristic @"49535343-8841-43F4-A8D4-ECBE34729BB3" //@"F000FFC2-0451-4000-B000-000000000000"//
//#define BTPrintService @"18F0"
//#define BTPrintCharisteristic @"2AF1"

@interface TWBlunoManager ()
{
    BOOL _bSupported;
    
    CBUUID *sUUID; //= [CBUUID UUIDWithString:kBlunoService];
    CBUUID *cUUID; //= [CBUUID UUIDWithString:kBlunoDataCharacteristic];
    
}

@property (strong,nonatomic) CBCentralManager* centralManager;
@property (strong,nonatomic) NSMutableDictionary* dicBleDevices;
@property (strong,nonatomic) NSMutableDictionary* dicBlunoDevices;

@end

@implementation TWBlunoManager

#pragma mark- Functions

+ (TWBlunoManager *)sharedInstance
{
	static TWBlunoManager* this	= nil;
    
    
    
	if (!this)
    {
		this = [[TWBlunoManager alloc] init];
        this.dicBleDevices = [[NSMutableDictionary alloc] init];
        this.dicBlunoDevices = [[NSMutableDictionary alloc] init];
        this->_bSupported = NO;
        this.centralManager = [[CBCentralManager alloc]initWithDelegate:this queue:nil];
    }
    
	return this;
}

- (void)configureSensorTag:(CBPeripheral*)peripheral
{
    
    //CBUUID *sUUID = [CBUUID UUIDWithString:kBlunoService];
    //CBUUID *cUUID = [CBUUID UUIDWithString:kBlunoDataCharacteristic];
    
    [BLEUtility setNotificationForCharacteristic:peripheral sCBUUID:sUUID cCBUUID:cUUID enable:YES];
    NSString* key = [peripheral.identifier UUIDString];
    DFBlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
    blunoDev->_bReadyToWrite = YES;
    if ([((NSObject*)_delegate) respondsToSelector:@selector(readyToPrint:)])
    {
        [_delegate readyToPrint:blunoDev];
    }
   
}

- (void)deConfigureSensorTag:(CBPeripheral*)peripheral
{
    
    //CBUUID *sUUID = [CBUUID UUIDWithString:kBlunoService];
   // CBUUID *cUUID = [CBUUID UUIDWithString:kBlunoDataCharacteristic];
    
    [BLEUtility setNotificationForCharacteristic:peripheral sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    
}

- (void)scan
{
    [self.centralManager stopScan];
    //[self.dicBleDevices removeAllObjects];
    //[self.dicBlunoDevices removeAllObjects];
    if (_bSupported)
    {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }

}

- (void)stop
{
    [self.centralManager stopScan];
}

- (void)clear
{
    [self.dicBleDevices removeAllObjects];
    [self.dicBlunoDevices removeAllObjects];
}

- (void)connectToDevice:(DFBlunoDevice*)dev
{
    BLEDevice* bleDev = [self.dicBleDevices objectForKey:dev.identifier];
    [bleDev.centralManager connectPeripheral:bleDev.peripheral options:nil];
}

- (void)disconnectToDevice:(DFBlunoDevice*)dev
{
    BLEDevice* bleDev = [self.dicBleDevices objectForKey:dev.identifier];
    [self deConfigureSensorTag:bleDev.peripheral];
    [bleDev.centralManager cancelPeripheralConnection:bleDev.peripheral];
}

- (void)writeDataToDevice:(NSData*)data Device:(DFBlunoDevice*)dev
{
    if (!_bSupported || data == nil)
    {
        return;
    }
    else if(!dev.bReadyToWrite)
    {
        return;
    }
    BLEDevice* bleDev = [self.dicBleDevices objectForKey:dev.identifier];
    [BLEUtility writeCharacteristic:bleDev.peripheral sUUID:[sUUID  UUIDString] cUUID:[cUUID UUIDString] data:data];
}

#pragma mark - CBCentralManager delegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBManagerStatePoweredOn)
    {
        _bSupported = NO;
        NSArray* aryDeviceKeys = [self.dicBlunoDevices allKeys];
        for (NSString* strKey in aryDeviceKeys)
        {
            DFBlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:strKey];
            blunoDev->_bReadyToWrite = NO;
        }
        
    }
    else
    {
        _bSupported = YES;
        
    }
    
    if ([((NSObject*)_delegate) respondsToSelector:@selector(printDidUpdateState:)])
    {
        [_delegate printDidUpdateState:_bSupported];
    }
    
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString* devName = peripheral.name;
    
  //  NSLog(@"BLE Device: %@", devName);
    
   // NSLog(devName);
    
    
    if([devName containsString:@"STAR"] || [devName containsString:@"Printer"]){
    
        
        if([devName containsString:@"STAR"]){
            
            sUUID = [CBUUID UUIDWithString:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"];
            cUUID = [CBUUID UUIDWithString:@"49535343-8841-43F4-A8D4-ECBE34729BB3"];
            
        }else{
         //   sUUID = [CBUUID UUIDWithString:@"F000FFC0-0451-4000-B000-000000000000"];
         //   cUUID = [CBUUID UUIDWithString:@"F000FFC2-0451-4000-B000-000000000000"];
            
            
            sUUID = [CBUUID UUIDWithString:@"18F0"];
            cUUID = [CBUUID UUIDWithString:@"2AF1"];

            
            
        }
        
        
        
        
        
        
    NSString* key = [peripheral.identifier UUIDString];
    BLEDevice* dev = [self.dicBleDevices objectForKey:key];
    if (dev !=nil )
    {
        //if ([dev.peripheral isEqual:peripheral])
        {
            dev.peripheral = peripheral;
            if ([((NSObject*)_delegate) respondsToSelector:@selector(didDiscoverPrinter:)])
            {
                DFBlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
                [_delegate didDiscoverPrinter:blunoDev];
            }
        }
    }
    else
    {
        BLEDevice* bleDev = [[BLEDevice alloc] init];
        bleDev.peripheral = peripheral;
        bleDev.centralManager = self.centralManager;
        [self.dicBleDevices setObject:bleDev forKey:key];
        DFBlunoDevice* blunoDev = [[DFBlunoDevice alloc] init];
        blunoDev.identifier = key;
        blunoDev.name = peripheral.name;
        [self.dicBlunoDevices setObject:blunoDev forKey:key];

        if ([((NSObject*)_delegate) respondsToSelector:@selector(didDiscoverPrinter:)])
        {
            [_delegate didDiscoverPrinter:blunoDev];
        }
    }
    }
}


-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSString* key = [peripheral.identifier UUIDString];
    DFBlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
    blunoDev->_bReadyToWrite = NO;
    if ([((NSObject*)_delegate) respondsToSelector:@selector(didDisconnectPrinter:)])
    {
        [_delegate didDisconnectPrinter:blunoDev];
    }
}

#pragma  mark - CBPeripheral delegate
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *s in peripheral.services) [peripheral discoverCharacteristics:nil forService:s];
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
   // NSString* uuidstr = [service.UUID UUIDString];
    
    if ([service.UUID isEqual:sUUID])
    {
        
        
        
        
        //for (CBCharacteristic *characteristic in service.characteristics) {
         //   NSLog(@"Discovered characteristic %@", characteristic);
           // NSString * chars = [characteristic.UUID UUIDString];
          //  NSLog(chars);
        
        //}
        
        [self configureSensorTag:peripheral];
    }

}


-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if ([((NSObject*)_delegate) respondsToSelector:@selector(didReceiveDataP:Device:)])
    {
        NSString* key = [peripheral.identifier UUIDString];
        DFBlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
        [_delegate didReceiveDataP:characteristic.value Device:blunoDev];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([((NSObject*)_delegate) respondsToSelector:@selector(didPrintData:)])
    {
        NSString* key = [peripheral.identifier UUIDString];
        DFBlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
        [_delegate didPrintData:blunoDev];
    }
    
}

@end
