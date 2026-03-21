-- (c) 2006 Travis Conway
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local addonName, ns = ...

SimpleIdentityDB = SimpleIdentityDB or {}

local function GetCharKey()
    return UnitName("player") .. "-" .. GetRealmName()
end

local function GetRealm()
    return GetRealmName()
end

local function GetIdentity()
    local realm = GetRealm()
    local serverData = SimpleIdentityDB.server and SimpleIdentityDB.server[realm]
    if serverData and serverData.enabled and serverData.identity then
        return serverData.identity
    end
    local charKey = GetCharKey()
    local charData = SimpleIdentityDB.characters and SimpleIdentityDB.characters[charKey]
    if charData and charData.identity then
        return charData.identity
    end
    return nil
end

local function SetIdentity(value)
    local realm = GetRealm()
    local serverData = SimpleIdentityDB.server and SimpleIdentityDB.server[realm]
    if serverData and serverData.enabled then
        SimpleIdentityDB.server[realm].identity = value
        print("|cff00ff00SimpleIdentity:|r Server identity set to [" .. value .. "] for " .. realm)
    else
        local charKey = GetCharKey()
        SimpleIdentityDB.characters = SimpleIdentityDB.characters or {}
        SimpleIdentityDB.characters[charKey] = SimpleIdentityDB.characters[charKey] or {}
        SimpleIdentityDB.characters[charKey].identity = value
        print("|cff00ff00SimpleIdentity:|r Identity set to [" .. value .. "] for " .. UnitName("player"))
    end
end

local function SetServerMode(enabled)
    local realm = GetRealm()
    SimpleIdentityDB.server = SimpleIdentityDB.server or {}
    SimpleIdentityDB.server[realm] = SimpleIdentityDB.server[realm] or {}
    SimpleIdentityDB.server[realm].enabled = enabled

    if enabled then
        -- Copy current character identity to server if server has none
        if not SimpleIdentityDB.server[realm].identity then
            local charKey = GetCharKey()
            local charData = SimpleIdentityDB.characters and SimpleIdentityDB.characters[charKey]
            if charData and charData.identity then
                SimpleIdentityDB.server[realm].identity = charData.identity
            end
        end
        print("|cff00ff00SimpleIdentity:|r Server mode |cff00ff00ON|r for " .. realm)
        local id = SimpleIdentityDB.server[realm].identity
        if id then
            print("|cff00ff00SimpleIdentity:|r All characters on " .. realm .. " will use [" .. id .. "]")
        else
            print("|cff00ff00SimpleIdentity:|r No identity set yet. Use /simpleid set <name>")
        end
    else
        print("|cff00ff00SimpleIdentity:|r Server mode |cffff0000OFF|r for " .. realm)
    end
end

local function PrintStatus()
    local realm = GetRealm()
    local serverData = SimpleIdentityDB.server and SimpleIdentityDB.server[realm]
    local serverOn = serverData and serverData.enabled
    print("|cff00ff00SimpleIdentity:|r Status for " .. UnitName("player") .. " on " .. realm)
    print("  Server mode: " .. (serverOn and "|cff00ff00ON|r" or "|cffff0000OFF|r"))
    local id = GetIdentity()
    print("  Active identity: " .. (id and ("[" .. id .. "]") or "|cffff0000not set|r"))
end

-- Pre-hook chat editboxes to rewrite the text BEFORE the default handler sends it.
-- HookScript runs after, so we replace the script and call the original ourselves.
local function InstallChatHooks()
    for i = 1, NUM_CHAT_WINDOWS do
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        if editBox and not editBox._simpleIdentityHooked then
            local origOnEnterPressed = editBox:GetScript("OnEnterPressed")
            editBox:SetScript("OnEnterPressed", function(self)
                local chatType = self:GetAttribute("chatType")
                if chatType == "GUILD" or chatType == "OFFICER" then
                    local identity = GetIdentity()
                    if identity then
                        local text = self:GetText()
                        if text and text ~= "" then
                            self:SetText("[" .. identity .. "] " .. text)
                        end
                    end
                end
                if origOnEnterPressed then
                    origOnEnterPressed(self)
                end
            end)
            editBox._simpleIdentityHooked = true
        end
    end
end

-- Slash command handler
SLASH_SIMPLEID1 = "/simpleid"
SlashCmdList["SIMPLEID"] = function(input)
    local args = {}
    for word in input:gmatch("%S+") do
        table.insert(args, word)
    end

    local cmd = args[1] and args[1]:lower() or ""

    if cmd == "set" then
        local value = input:match("^%s*%S+%s+(.+)$")
        if not value or value:match("^%s*$") then
            print("|cff00ff00SimpleIdentity:|r Usage: /simpleid set <name>")
            return
        end
        SetIdentity(value)

    elseif cmd == "server" then
        local toggle = args[2] and args[2]:lower() or ""
        if toggle == "on" then
            SetServerMode(true)
        elseif toggle == "off" then
            SetServerMode(false)
        else
            print("|cff00ff00SimpleIdentity:|r Usage: /simpleid server on|off")
        end

    elseif cmd == "status" then
        PrintStatus()

    else
        print("|cff00ff00SimpleIdentity|r commands:")
        print("  /simpleid set <name> - Set your identity tag")
        print("  /simpleid server on|off - Share identity across all characters on this realm")
        print("  /simpleid status - Show current settings")
    end
end

-- Init
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    InstallChatHooks()
    PrintStatus()
end)
