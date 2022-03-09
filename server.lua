--변수 너무 숨길려고 노력을 해서 ㅠㅠ..
 
resource_name = "AntiGG"

    local function connecting(a, b, c)
        for a, stringmatch in pairs(GetPlayerIdentifiers(source)) do
            if string.sub(stringmatch, 1, string.len("discord:")) == "discord:" or string.sub(stringmatch, 1, string.len("steam:")) == "steam:" then
                ifend = stringmatch
            end
            if not Config.SteamorDiscord then
                ifend = stringmatch
            end
        end
        if ifend then
            local ip = tostring(GetPlayerEndpoint(source))
            c.defer()
            Citizen.Wait(500)
            c.update("["..resource_name.."] "..Config.FetchNetworkData..".")
            Citizen.Wait(500)
            c.update("["..resource_name.."] "..Config.FetchNetworkData.."..")
            Citizen.Wait(500)
            c.update("["..resource_name.."] "..Config.FetchNetworkData.."...")
            Citizen.Wait(500)
            c.update("["..resource_name.."] "..Config.FetchNetworkData.."..")
            for vpnip, tosting in pairs(Config.AntiGG_Whitelist) do   
                if ip ~= nil and ip ~= tosting then  
                    PerformHttpRequest(
                        "https://blackbox.ipinfo.app/lookup/" .. ip,
                        function(errorCode, resultDatavpn, resultHeaders)
                            if errorCode == 200 then
                                if resultDatavpn == "N" then
                                    Citizen.Wait(500)
                                    c.update("["..resource_name.."] "..Config.FetchNetworkData..".")
                                    PerformHttpRequest("http://ip-api.com/json/" .. ip .. "?fields=proxy", function(err, text, headers)
                                        if tonumber(err) == 200 then
                                            local json = json.decode(text)
                                            if json["proxy"] == false then
                                                c.done()
                                            else
                                                c.done("["..resource_name.."] "..Config.AntiGG_ConnectVpn.."")
                                            end
                                        else
                                            print("["..resource_name.."] ^1Offline Error Code: "..errorCode.."")
                                            c.done()
                                        end
                                    end)
                                else
                                    c.done("["..resource_name.."] "..Config.AntiGG_ConnectVpn.."")
                                end
                            else
                                print("["..resource_name.."] ^1Offline Error Code: "..errorCode.."")
                                c.done()
                            end
                        end
                    )
                else
                    if ip == tosting then
                        c.update("["..resource_name.."] "..Config.AntiGG_ConnectWhitelist.."")
                        Citizen.Wait(1000)
                        c.done()
                    else
                        c.update("["..resource_name.."] "..Config.AntiGG_NotFoundIPDATA.."")
                    end  
                end
            end
        else
            c.done("["..resource_name.."] "..Config.AntiGG_ConnectSteamDiscord.."")
        end
    end

    AddEventHandler("playerConnecting", connecting)