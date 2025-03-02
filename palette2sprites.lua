-------------------------------------------------------------------------------
-- palette2textures
-- Description: Script slices 1px sized palette into squared 64x64 textures. 
-- Author: msun_
-------------------------------------------------------------------------------

if app.activeSprite == nil then
  app.alert("You should open a palette file first")
  return nil
end

function processPalette(data)
  local sprite = app.activeSprite
  local palette = app.sprite.palettes[1]
  local ncolors = #palette
  for i=1, ncolors-1 do -- iteration starts from 1 since there is transparent
                        -- color added to a palette
    local color = palette:getColor(i)
    createSpriteFromColor(sprite, data.sprite_size, color, 
                          i, data.save_path, data.extension)
  end
  app.alert("Done creating sprites!")
end

function getPalette(sprite)
  local palette = sprite.palettes[1]
  return palette
end

function createSpriteFromColor(sprite, size, color, name, save_path, extension)
  local color_sprite = Sprite(size, size)
  color_sprite.filename = name
  cel = app.activeCel
  img = cel.image:clone()
  for pixel in img:pixels() do
    pixel(app.pixelColor.rgba(color.red, color.green, color.blue))
  end
  cel.image = img
  local save_path_full = string.format(save_path .. name .. extension) 
  app.command.SaveFile { filename=save_path_full }
  color_sprite:close()
end

local dlg = Dialog()
dlg:label{ label="Output parameters:"}
dlg:number{ id="sprite_size", label="Sprite size (px)", text="64"}
dlg:entry{ id="save_path", label="Save path", text="/"}
dlg:entry{ id="extension", label="File extension", text=".*"} 
dlg:button{ id="confirm", text="Confirm!", 
  onclick=function()
    local data = dlg.data
    dlg:close()
    processPalette(data)
  end
}
dlg:show()

