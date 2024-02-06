# servodoor-matlab: a simple matlab library for controlling RC servo based doors 

Servo door is a simple library for controlling (RC servo) doors  via via
Pimoroni's [Servo 2040](https://shop.pimoroni.com/products/servo-2040)
18-channel servo controller. Initially designed for use in T-maze type
experiments. The Serovo 2040 must be running the
[servodoor-firmware](https://github.com/willdickson/servodoor-firmware)

## Installing
Add the servodoor-matlab/src directory to your Matlab PATH. 
```


## Usage

```
function servodoor_example()
    % servodoor_example: simple example function demonstrating how to use
    % ServoDoor.
    %
    % Change the value of port to match the port associated with your ServoDoor
    % device, e.g. on windows COM1, COM2, etc.  and on linux /dev/ttyACM0,
    % /dev/ttyACM1, etc.

    port = '/dev/ttyACM0';
    fprintf('\nport = %s\n\n', port)

    dev = ServoDoor(port);

    % Get the current device configuration as a struct
    config = dev.get_config();
    fprintf('config = \n');
    disp(config);

    % Get the current door positions
    positions = dev.get_positions();
    fprintf('positions = \n');
    disp(positions);

    % Disable/Enable examples
    fprintf('check if door servos are enabled\n');
    is_enabled = dev.is_enabled();
    fprintf('is_enabled = %s\n\n', string(is_enabled));

    fprintf('disabling door servos\n')
    dev.disable();

    fprintf('check again if door servos are enabled\n')
    is_enabled = dev.is_enabled();
    fprintf('is_enabled = %s\n\n', string(is_enabled));

    fprintf('enabling door servos\n')
    dev.enable();

    fprintf('check yet again if door servos are enabled\n')
    is_enabled = dev.is_enabled();
    fprintf('is_enabled = %s\n\n', string(is_enabled));

    % Get/Set door open/close states
    fprintf('getting the current door open/close states\n')
    doors = dev.get_doors();
    fprintf('doors = \n');
    disp(doors);

    fprintf('toggle state of doors, i.e., open doors which are closed ');
    fprintf('and close doors which are open');
    dn = fieldnames(doors);
    for i = 1:numel(dn)
        if strcmp(doors.(dn{i}), 'open')
            doors.(dn{i}) = 'close';
        else
            doors.(dn{i}) = 'open';
        end
    end
    dev.set_doors(doors);

    fprintf('getting the current door open/close states\n')
    doors = dev.get_doors();
    fprintf('doors = \n');
    disp(doors);

end
```

