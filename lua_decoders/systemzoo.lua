

require "string"
require "cjson"
-- 2015-06-20 20:29:12,386 INFO  com.systemzoo.TestServiceActor  - {"code":500,"duration":528, "request":1, "response":2}
-- 2015-06-20 20:34:12,757 INFO  com.systemzoo.TestServiceActor  - {"code":200,"duration":0}
-- sample input {"name":"android_app_created","created_at":"2013-11-15 22:37:34.709739275"}

local output = {}
local date_pattern = '^(%d+-%d+-%d+)%s(%d+:%d+:%d+)'
local json_pattern = '(%{.+%})'

function process_message ()
    local payload = read_message("Payload")
    -- local _,_,date,time = string.find(payload, date_pattern)
    -- local _,_,jsonString = string.find(payload, json_pattern)

    local ok, json = pcall(cjson.decode, payload)
    if not ok then
        return -1
    end

    local containerID = read_message("Fields[ContainerID]")
    local containerName = read_message("Fields[ContainerName]")

    local message = {
        containerid = containerID,
        containername = containerName,
        Fields = nil
    }
    message.Fields = json
    inject_message(message)
--    inject_payload("json", "systemzoo_encoder", cjson.encode(message))
    return 0
end

-- sample output
--2013/11/15 15:25:56 <
--      Timestamp: 2013-11-15 15:25:56.826184879 -0800 PST
--      Type: logfile
--      Hostname: trink-x230
--      Pid: 0
--      UUID: ef5de908-822a-4fe1-a564-ad3b5a9631c6
--      Logger: test.log
--      Payload: {"name":"android_app_created","created_at":"2013-11-15T22:37:34.709739275Z"}
--
--      EnvVersion: 0.8
--      Severity: 0
--      Fields: [name:"payload_type" value_type:STRING representation:"file-extension" value_string:"json"  name:"payload_name" value_type:STRING representation:"" value_string:"transformed timestamp" ]
