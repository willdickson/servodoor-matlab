

classdef ServoDoor < handle
% ServoDoor: Creates a serial client for communication with the ServoDoor
% device. 
%
%    dev = ServoDoor(port) constructs a ServoDoor object, dev, associated
%    with the port value , port.  Automatically connects to device.  
%   
%   Methods:
%    <a href="matlab:help ServoDoor.enable">enable</a>
%    <a href="matlab:help ServoDoor.disable">disable</a>
%    <a href="matlab:help ServoDoor.is_enabled">is_enabled</a>
%    <a href="matlab:help ServoDoor.get_doors">get_doors</a>
%    <a href="matlab:help ServoDoor.set_doors">set_doors</a>
%    <a href="matlab:help ServoDoor.get_config">get_config</a>
%    <a href="matlab:help ServoDoor.get_config_errors">get_config_errors</a>
%    <a href="matlab:help ServoDoor.get_positions">get_positions</a>
% 

    properties
        dev = [];
    end

    properties (Constant)
        baudrate = 115200;
        databits = 8;
        stopbits = 1;
        timeout = 2.0;
        num_throw_away= 10;
    end

    methods (Access = public)
        function self = ServoDoor(port)
            % ServoDoor Class Constructor.
            % 
            % dev = ServoDoor(port) constructs a new ServoDoor object, dev, 
            % associated with the serial port name 'port'.
            if (nargin~=1)
                error('Usage: self = SeroDoor(port)');
            end
            self.dev = serialport(port, self.baudrate, ...
                'DataBits', self.databits, ...
                'StopBits', self.stopbits, ...
                'Timeout',  self.timeout ...
                );
        end

        function enable(self)
            % enable - enables the door control servos
            %
            %   dev.enable() enables the door control servos for ServoDoor
            %   object dev. 
            %
            msg.cmd = 'enable';
            self.send_and_receive(msg);
        end

        function disable(self)
            % disable - disables the door control servos
            %
            %   dev.disable() disables the door control servos for
            %   ServoDoor object dev. 
            %
            msg.cmd = 'disable';
            self.send_and_receive(msg);
        end

        function val = is_enabled(self)
            % is_enabled - returns true if door control servos are
            % enabled and false otherwise.
            %
            %   dev.is_enabled() returns the enabled state of the doors for
            %   ServoDoor device object dev. 
            %
            msg.cmd = 'is_enabled';
            rsp = self.send_and_receive(msg);
            val = rsp.is_enabled;
        end

        function doors = get_doors(self)
            % get_doors - returns the current state of the doors where 
            % 'doors' is a struct with a field for each door which 
            % specifies whether or not it is int 'open' or 'close' state, 
            % e.g. for each door door.name = 'open' or door.name = 'close'
            %
            %   door = dev.get_doors() returns the state of the doors
            %   for ServoDoor device object dev.  
            %
            msg.cmd = 'get_doors';
            rsp = self.send_and_receive(msg);
            doors = rsp.doors;
        end

        function set_doors(self, doors)
            % set_doors - sets the value of the devices doors using the 
            % doors struct where doors.name = 'open' or doors.name ='close'.
            % Not all doors need to be specified only those whose state you
            % wish to change. 
            %
            %   doors.left = 'open'
            %   doors.right = 'close'
            %   dev.set_doors(doors) opens the door named 'left' and closes
            %   the door names 'right' for ServoDoor device object dev.
            %

            % dev.set_doors(doors) 
            msg.cmd = 'set_doors';
            msg.doors = doors;
            self.send_and_receive(msg);
        end

        function config = get_config(self)
            % get_config - returns the current device configuration as a 
            % struct. 
            %
            %   config = dev.get_config() returns the device configuration
            %   for ServoDevice device object dev as a struct. 
            %
            msg.cmd = 'get_config';
            rsp = self.send_and_receive(msg);
            config = rsp.config;
        end

        function config_errors = get_config_errors(self)
            % get_config_errors - returns any errors in the current
            % configuration.  Used to debug issues with the configuration. 
            %
            %   config_errors = dev.get_config_errors() returns the error
            %   in the configuration for ServoDoor device object dev. 
            %
            msg.cmd = 'config_errors';
            rsp = self.send_and_receive(msg);
            config_errors = rsp.config_errors;
        end

        function positions = get_positions(self)
            % get_positions - returns the current positions of all doors.
            % The positions are returned as a struct with a field for each
            % door name giving the current position of that door. 
            %
            %   positions = dev.get_positions() returns the current
            %   positions of the doors for ServoDoor device object dev. 
            %
            msg.cmd = 'positions';
            rsp = self.send_and_receive(msg);
            positions = rsp.positions;
        end

    end

    methods (Access = protected)
        
        function rsp = send_and_receive(self,msg)
            % send_and_recieve
            %
            % dev.send_and_receive(msg) ends message to the ServoDoor device, 
            % dev, then waits for and reads the corresponding response.
            msg_json = jsonencode(msg);
            self.dev.writeline(msg_json);
            rsp_json = self.dev.readline();
            rsp = jsondecode(rsp_json);
        end

        % function throw_away_lines(self)
        %     % throw_away_lines
        %     %
        %     % dev.throw_way_lines() reads data from seiral port and throws 
        %     % away a fixed number of lines. Its purpose is to remove any
        %     % possible junk left in buffer. 
        %     % TODO: check to see if we really need this. 
        %     self.dev.Timeout = 0.1;
        %     warning('off','serialport:serialport:ReadlineWarning');
        %     for i=1:self.num_throw_away
        %         self.dev.readline();
        %     end
        %     warning('on','serialport:serialport:ReadlineWarning');
        %     self.dev.Timeout=self.timeout;
        % end

    end
end