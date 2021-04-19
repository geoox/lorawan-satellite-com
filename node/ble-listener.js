const bleno = require('bleno');
bleno.on('stateChange', function(state) {
    console.log('on stateChange: ' + state);
    if (state === 'poweredOn') {
      bleno.startAdvertising('ble-RaspPi', ['1803']);
    } else {
      bleno.stopAdvertising();
    }
});

// Notify the console that we've accepted a connection
bleno.on('accept', function(clientAddress) {
    console.log("Accepted connection from address: " + clientAddress);
});

// Notify the console that we have disconnected from a client
bleno.on('disconnect', function(clientAddress) {
    console.log("Disconnected from address: " + clientAddress);
});

bleno.on('advertisingStart', function(error) {
    if (error) {
        console.log("Advertising start error:" + error);
    } else {
        console.log("Advertising start success");
        bleno.setServices([
            
            // Define a new service
            new bleno.PrimaryService({
                uuid : '12ab',
                characteristics : [
                    
                    // Define a new characteristic within that service
                    new bleno.Characteristic({
                        value : null,
                        uuid : '34cd',
                        properties : ['notify', 'read', 'write'],
                        
                        // // If the client subscribes, we send out a message every 1 second
                        // onSubscribe : function(maxValueSize, updateValueCallback) {
                        //     console.log("Device subscribed");
                        //     this.intervalId = setInterval(function() {
                        //         console.log("Sending: Hi!");
                        //         updateValueCallback(new Buffer("Hi!"));
                        //     }, 1000);
                        // },
                        
                        // // If the client unsubscribes, we stop broadcasting the message
                        // onUnsubscribe : function() {
                        //     console.log("Device unsubscribed");
                        //     clearInterval(this.intervalId);
                        // },
                        
                        
                        // Accept a new value for the characterstic's value
                        onWriteRequest : function(data, offset, withoutResponse, callback) {
                            this.value = data;
                            console.log('Write request: value = ' + this.value.toString("utf-8"));
                            callback(this.RESULT_SUCCESS);
                        }

                    })
                    
                ]
            })
        ]);
    }
});
