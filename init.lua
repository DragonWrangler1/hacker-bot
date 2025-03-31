-- April Fools' Mod: Ultimate Hacker Prank Mode
-- Random fake error messages to spook players, plus bizarre, funny effects for 10 seconds!

minetest.register_globalstep(function(dtime)
    if math.random(1, 600) == 1 then -- Roughly every 20-40 seconds
        for _, player in ipairs(minetest.get_connected_players()) do
            local name = player:get_player_name()
            local messages = {
                "ALERT! Your PC has been infected with *LOL*virus!",
                "DANGER: System Overload! Reboot in 5 seconds!",
                "OH NO! Someone is sending you *spaghetti* malware!",
                "CRITICAL ERROR: The game's loading... too much fun!",
                "ERROR: Internet is broken, please cry!",
                "GAME BREAKING BUG: Your character is now a potato.",
                "INFINITE LOOPS DETECTED: Brace for lag… or maybe not.",
                "WHAT?! Your coordinates are visible to everyone now, no escape!",
                "WARNING: Hacking detected... or maybe you're just *awesome*.",
                "OH, YOU'RE SO BANNED! Wait... am I kidding?",
                "ALERT: Your computer is running on juice boxes. Get a real power supply!"
            }
            local msg = messages[math.random(#messages)]
            
            -- Display message as a HUD element
            local hud_id = player:hud_add({
                hud_elem_type = "text",
                position = {x = 0.5, y = 0.2},
                offset = {x = 0, y = 0},
                text = minetest.colorize("#ff0000", msg),
                alignment = {x = 0, y = 0},
                scale = {x = 2, y = 2},
                number = 0xFF0000
            })
            
            -- Apply random effects for 10 seconds
            local effects = {
                function(p) p:set_physics_override({speed = 0.2}) end, -- Slow motion, like a bad dream
                function(p) p:set_physics_override({jump = 5}) end, -- *Super* jump, fly to the moon
                function(p) p:set_hp(math.max(1, p:get_hp() - 2)) end, -- Fake damage (but just a little!)
                function(p) minetest.sound_play("default_dig_cracky", {to_player = name, gain = 5.0}) end, -- Ridiculously loud random sound
                function(p) p:set_eye_offset({x = 10, y = 10, z = 10}, {x = -10, y = -10, z = -10}) end, -- Absurdly distorted vision
                function(p) p:set_physics_override({sneak = false}) end, -- Suddenly, sneaking is illegal
                function(p) p:set_physics_override({gravity = 0.05}) end, -- Float like a feather in low gravity
                function(p) p:set_hp(p:get_hp() + 5) end, -- Fake healing, now you're invincible!
                function(p) minetest.sound_play("default_break_glass", {to_player = name, gain = 10.0}) end, -- Glass shattering, in the middle of nowhere
                function(p) minetest.chat_send_all("[ALERT] Player " .. name .. " is being hacked by *the game*!!") end, -- Broadcast fake hack attack
                -- Vision effects
                function(p) p:set_eye_offset({x = math.random(-20, 20), y = math.random(-20, 20), z = math.random(-20, 20)}, {x = math.random(-20, 20), y = math.random(-20, 20), z = math.random(-20, 20)}) end, -- Truly random vision distortion
                -- Fake crash screen
                function(p)
                    local crash_hud_id = p:hud_add({
                        hud_elem_type = "text",
                        position = {x = 0.5, y = 0.5},
                        text = minetest.colorize("#ff00ff", "CRITICAL SYSTEM FAILURE: Please restart"),
                        alignment = {x = 0, y = 0},
                        scale = {x = 3, y = 3},
                        number = 0xFF00FF
                    })
                    -- Remove the crash screen after 10 seconds
                    minetest.after(5, function()
                        p:hud_remove(crash_hud_id)
                    end)
                end,
                -- Glitchy Lighting Effect
				function(p)
                    -- Apply a random lighting effect with saturation, shadows, and exposure
                    local saturation = math.random(0, 2) * 0.5  -- Saturation between 0, 0.5, and 1
                    local shadow_intensity = math.random(0, 1) * 0.5  -- Shadows: 0 (no shadows) to 0.5 (faint shadows)
                    local exposure_correction = math.random(-5, 5) * 0.1  -- Exposure correction between -0.5 and 0.5
                    local volumetric_strength = math.random(0, 1) * 0.5  -- Volumetric light strength (godrays)

                    p:set_lighting({
                        saturation = saturation,
                        shadows = {
                            intensity = shadow_intensity,
                            tint = {r = 255, g = 0, b = 0} -- Red shadow tint for extra weirdness
                        },
                        exposure = {
                            exposure_correction = exposure_correction,
                            luminance_min = -3.0,
                            luminance_max = 3.0,
                            speed_dark_bright = 1000.0,
                            speed_bright_dark = 1000.0
                        },
                        volumetric_light = {
                            strength = volumetric_strength
                        }
                    })
                    
                    -- Reset lighting to default after 10 seconds
                    minetest.after(5, function()
                        p:set_lighting()  -- Reset lighting to default
                    end)
                end,
                function(p)
                    local static_hud_id = p:hud_add({
						hud_elem_type = "image",
						position = {x = 0.5, y = 0.5},
						scale = {x = -200, y = -200},
						text = "static.png", -- Fake static, like your screen just fell into a time warp
						alignment = {x = 0, y = 0},
						number = 0xFFFFFF
                    })
                    local message_hud_id = p:hud_add({
                        hud_elem_type = "text",
                        position = {x = 0.5, y = 0.5},
                        text = minetest.colorize("#ff0000", "SYSTEM HACK IN PROGRESS"),
                        alignment = {x = 0, y = 0},
                        scale = {x = 3, y = 3},
                        number = 0xFF00FF
                    })
                    -- Remove the crash screen after 10 seconds
                    minetest.after(5, function()
                        p:hud_remove(static_hud_id)
                        p:hud_remove(message_hud_id)
                    end)
                end
            }

            -- When the "You have been hacked by the game" message is triggered, disable player control for 5 seconds
            if msg == "WARNING: Hacking detected... or maybe you're just *awesome*." then
                -- Lock player movement by overriding physics
                player:set_physics_override({speed = 0, jump = 0, sneak = false, gravity = 0})

                -- After 5 seconds, restore control
                minetest.after(5, function()
                    player:set_physics_override({speed = 1, jump = 1, sneak = true, gravity = 1})
                end)
            elseif msg == "GAME BREAKING BUG: Your character is now a potato." then
            	    -- Change the player texture to a potato (assuming you have a potato texture)
                    player:set_properties({
                        textures = {"potato.png"} -- Replace with your actual potato texture path
                    })
                    -- After 10 seconds, restore original texture (use default texture)
                    minetest.after(5, function()
                        player:set_properties({
                            textures = {"character.png"} -- Default texture
                        })
                    end)
            elseif msg == "OH NO! Someone is sending you *spaghetti* malware!" then
            	local spaghetti_hud_id = player:hud_add({
					hud_elem_type = "image",
					position = {x = 0.5, y = 0.5},
					scale = {x = -100, y = -100},
					text = "spaghetti_malware.png",
					alignment = {x = 0, y = 0.2},
					number = 0xFFFFFF
				})
                    -- Remove the crash screen after 10 seconds
                    minetest.after(5, function()
                        player:hud_remove(spaghetti_hud_id)
                    end)
            end

            local effect = effects[math.random(#effects)]
            effect(player)
            
            -- Remove other effects after 10 seconds
            minetest.after(5, function()
                player:set_physics_override({speed = 1, jump = 1, sneak = true, gravity = 1})
                player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
                player:hud_remove(hud_id)
            end)
        end
    end
end)


