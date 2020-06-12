
local obj={}
obj.__index = obj

-- Metadata
obj.name = 'DownloadAtp'
obj.version = '0.1'
obj.author = 'Eugene Bravov <eugene.bravov@gmail.com>'
obj.homepage = 'https://github.com/fullpipe/DownloadAtp.spoon'
obj.license = 'MIT - https://opensource.org/licenses/MIT'

function obj:init()
    self.log = hs.logger.new('DownloadAtp','debug')
    self.log.i('Initializing')

    self.volumeWatcher = hs.fs.volume.new(
        function(eventType, event)
            if eventType ~= hs.fs.volume.didMount then
                return
            end

            if hs.fs.displayName(self.downloadDir) == nil then
                return
            end

            hs.http.asyncGet("https://atp.fm", {}, function(status, html, header)
                if status ~= 200 then
                    return
                end

                for l in html:gmatch("<a href=\"([^\"]-)\"[^>]*>Download</a>") do
                    local fileName = l:match "^.+/(.-.mp3).-$"
                    print(fileName)
                    print(hs.fs.displayName(self.downloadDir .. "/" .. fileName))
                    --print(hs.fs.displayName("/Volumes/U5/Datacasts/"))
                    if hs.fs.displayName(self.downloadDir .. "/" .. fileName) ~= nil then
                        self.log.i("Podcast " .. fileName .." already exists")
                    else
                        self.log.i("Downloading " .. l)
                        mp3Status, mp3Data, mp3Header = hs.http.get(l)
                        if not mp3Data then error(mp3Status) end

                        -- save the content to a file
                        local f = assert(io.open(self.downloadDir .. "/" .. fileName, 'wb')) -- open in "binary" mode
                        self.log.i("Writing " .. l .." to " .. self.downloadDir .. "/" .. fileName)
                        f:write(mp3Data)
                        f:close()
                        self.log.i("Coplete " .. l)
                    end
                end
            end)
        end
    )
end

--- Caps2Esc:start()
--- Method
--- Starts watch for volumes
function obj:start(downloadDir)
    self.downloadDir = downloadDir
    self.volumeWatcher:start()
end

--- Caps2Esc:stop()
--- Method
--- Stops watching volumes
function obj:stop()
    self.volumeWatcher:stop()
end

return obj
