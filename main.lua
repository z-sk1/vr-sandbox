local shapes = { "cubes", "spheres", "yv", "the knight", "hornet", "wheatley" }
local shapeIndex = 1

local objects = {}

local player = { x = 0, y = -1, z = 0 }
local hands = {}

local world = lovr.physics.newWorld(0, -4.9, 0)

local startMenuButtons = {
  { id = "start", label = "Start", x = -0.15, y = 0, z = 0, pointingAt = false },
  { id = "settings", label = "Settings", x = -0.15, y = -0.1, z = 0, pointingAt = false },
  { id = "quit", label = "Quit", x = -.15, y = -.2, z = 0, pointingAt = false },
}
local buttonSize = { w = 0.25, h = 0.1, d = 0.02 }

local volume = 0.5 

local settingsMenuButtons = {
  { id = "volume", type = "toggle", label = "Volume: " .. tostring((volume * 100)) .. "%", x = -.15, y = 0, z = 0, pointingAt = false, isOn = true },
  { id = "hitbox", type = "toggle", label = "Hitbox", x = -.15, y = -.1, z = 0, pointingAt = false, isOn = false },
  { id = "raylength", label = "Ray Length", x = -.15, y = -.2, z= 0, pointingAt = false, isOn = false}
  { id = "back", label = "Back", x = -.15, y = -.3, z = 0, pointingAt = false },
}
lovr.audio.setVolume(volume)

local pauseMenuButtons = {
  { id = "unpause", label = "Unpause", x = -.15, y = 0, z = 0, pointingAt = false },
  { id = "settings", label = "Settings", x = -.15, y = -.1, z = 0, pointingAt = false },
  { id = "titlescreen", label = "Main Menu", x = -.15, y = -.2, z = 0, pointingAt = false }
}

function drawStartMenu(pass)
  local hx, hy, hz = lovr.headset.getPosition("head")

  local fx, _, fz = lovr.headset.getDirection("head")
  local forward = lovr.math.newVec3(fx, 0, fz)
  forward:normalize()

  local menuX = hx + forward.x * 1
  local menuY = hy
  local menuZ = hz + forward.z * 1

  local rayLength = 1
  local wx, wy, wz = lovr.headset.getPosition("hand/right")
  local dx, dy, dz = lovr.headset.getDirection("hand/right")
  pass:setColor(1, 1, 0) -- yellow
  pass:line(wx, wy, wz, wx + dx*rayLength, wy + dy*rayLength, wz + dz*rayLength)


  pass:setColor(0, 0, 0, 0.7) -- dark semi-transparent background
  pass:box(menuX, menuY, menuZ, 0.6, 0.3, 0.01) -- flat rectangle

  pass:setColor(1, 1, 1)
  pass:text("the Playground", menuX, menuY + 0.1, menuZ + 0.02, 0.05, 0, 0)

  for i, btn in ipairs(startMenuButtons) do
    local color
    
    if btn.pointingAt then
      color  = {0.8, 0.8, 0.2}
    else
      color = {0.2, 0.2, 0.2}
    end

    pass:setColor(color)
    pass:box(menuX + btn.x, menuY + btn.y, menuZ + btn.z, buttonSize.w, buttonSize.h, buttonSize.d)

    pass:setColor(1, 1, 1)
    pass:text(btn.label, menuX + btn.x, menuY + btn.y, menuZ + btn.z + 0.015, 0.04, 0, 0)
  end
end

function drawSettingsMenu(pass) 
  local hx, hy, hz = lovr.headset.getPosition("head")

  local fx, _, fz = lovr.headset.getDirection("head")
  local forward = lovr.math.newVec3(fx, 0, fz)
  forward:normalize()

  local menuX = hx + forward.x * 1
  local menuY = hy
  local menuZ = hz + forward.z * 1

  local rayLength = 1
  local wx, wy, wz = lovr.headset.getPosition("hand/right")
  local dx, dy, dz = lovr.headset.getDirection("hand/right")
  pass:setColor(1, 1, 0) -- yellow
  pass:line(wx, wy, wz, wx + dx*rayLength, wy + dy*rayLength, wz + dz*rayLength)

  pass:setColor(0, 0, 0, 0.7)
  pass:box(menuX, menuY, menuZ, 0.6, 0.3, 0.01)

  pass:setColor(1, 1, 1)
  pass:text("settings", menuX, menuY + 0.1, menuZ + 0.02, 0.05, 0, 0)

  for i, btn in ipairs(settingsMenuButtons) do
    local color 

    if btn.pointingAt then
      color = {0.8, 0.8, 0.2}
    else
      color = {0.2, 0.2, 0.2}
    end

    pass:setColor(color)
    pass:box(menuX + btn.x, menuY + btn.y, menuZ + btn.z, buttonSize.w, buttonSize.h, buttonSize.d)

    local txtColor
    if btn.type == "toggle" then 
      if btn.isOn then
        txtColor = {0, 1, 0}
      else
        txtColor = {1, 0, 0}
      end 
    else
      txtColor = {1, 1, 1}
    end 

    pass:setColor(txtColor)
    pass:text(btn.label, menuX + btn.x, menuY + btn.y, menuZ + btn.z + 0.015, 0.04, 0, 0)
  end
end 

function drawPauseMenu(pass)
  local hx, hy, hz = lovr.headset.getPosition("head")

  local fx, _, fz = lovr.headset.getDirection("head")
  local forward = lovr.math.newVec3(fx, 0, fz)
  forward:normalize()

  local menuX = hx + forward.x * 1
  local menuY = hy
  local menuZ = hz + forward.z * 1

  local rayLength = 1
  local wx, wy, wz = lovr.headset.getPosition("hand/right")
  local dx, dy, dz = lovr.headset.getDirection("hand/right")
  pass:setColor(1, 1, 0) -- yellow
  pass:line(wx, wy, wz, wx + dx*rayLength, wy + dy*rayLength, wz + dz*rayLength)

  pass:setColor(0, 0, 0, 0.7)
  pass:box(menuX, menuY, menuZ, 0.6, 0.3, 0.01)

  pass:setColor(1, 1, 1)
  pass:text("paused", menuX, menuY + 0.1, menuZ + 0.02, 0.05, 0, 0)

  for i, btn in ipairs(pauseMenuButtons) do
    local color

    if btn.pointingAt then
      color =  {0.8, 0.8, 0.2}
    else
      color = {0.2, 0.2, 0.2}
    end

    pass:setColor(color)
    pass:box(menuX + btn.x, menuY + btn.y, menuZ + btn.z, buttonSize.w, buttonSize.h, buttonSize.d)

    local txtColor = {1, 1, 1}

    pass:setColor(txtColor)
    pass:text(btn.label, menuX + btn.x, menuY + btn.y, menuZ + btn.z + 0.015, 0.04, 0, 0)
  end
end 

function drawShapeIndicator(pass)
  local hand = hands.right
  if not hand then return end

  local x, y, z = hand.col:getPosition()
  y = y + 0.3 -- slightly above the hand
  local angle = lovr.headset.getTime()

  pass:setColor(1, 1, 1) -- white outline

  if shapes[shapeIndex] == "cubes" then
    pass:cube(x, y, z, 0.1, angle)
  elseif shapes[shapeIndex] == "spheres" then
    pass:sphere(x, y, z, 0.1, angle)
  elseif shapes[shapeIndex] == "yv" then
    pass:draw(yvModel, x, y, z, .00125, angle)
  elseif shapes[shapeIndex] == "the knight" then
    pass:draw(knightModel, x, y, z, .0025, angle)
  elseif shapes[shapeIndex] == "hornet" then
    pass:draw(hornetModel, x, y, z, .05, angle)
  elseif shapes[shapeIndex] == "wheatley" then
    pass:draw(wheatleyModel, x, y, z, .005, angle)
  end
end

function lovr.load()
  math.randomseed(lovr.headset.getTime())
  gameState = "start"

  -- physics floor
    local floorCollider = world:newBoxCollider(0, -1, 0, 100, 0.2, 100)
    floorCollider:setKinematic(true)

    floor = {
      col = floorCollider,
      size = lovr.math.newVec3(100, 0.2, 100),
      color = { .3, .3, .3 }
    }
  -- create hand cols
  for _, hand in ipairs({ 'left', 'right' }) do
    local col = world:newSphereCollider(0, 1.5, -1, 0.1)
    col:setKinematic(true)
    hands[hand] = {
      col = col,
      held = nil, -- which cube is being held
      lastPos = lovr.math.newVec3(0, 0, 0), -- for throw velocity
      velocity = lovr.math.newVec3(0, 0, 0)
    }
  end

  yvModel = lovr.graphics.newModel('models/yv Model/scene.gltf')
  knightModel = lovr.graphics.newModel('models/knight Model/scene.gltf')
  hornetModel = lovr.graphics.newModel('models/hornet Model/scene.gltf')
  wheatleyModel = lovr.graphics.newModel('models/wheatley Model/scene.gltf')

  backgroundMus = {
    lovr.audio.newSource('sounds/background1.wav', { decode = false }),
    lovr.audio.newSource('sounds/background2.wav', { decode = false }),
    lovr.audio.newSource('sounds/background3.wav', { decode = false }),
    lovr.audio.newSource('sounds/background4.wav', { decode = false }),
  }

  currentTrack = nil 

  playRandomTrack(nil)

  sfx = {

  }
end

function playRandomTrack(exclude)
  local choice
  repeat
    choice = math.random(1, #backgroundMus)
  until choice ~= exclude


  if currentTrack then
    backgroundMus[currentTrack]:stop()
  end
  backgroundMus[choice]:play()
  currentTrack = choice
end 

function spawnCube(x, y, z, size)
  local col = world:newBoxCollider(x, y, z, size, size, size)
  col:setRestitution(.3) -- bouncy
  return col
end

function spawnSphere(x, y, z, size)
  local col = world:newSphereCollider(x, y, z, size)
  col:setRestitution(.3)
  return col 
end

function lovr.update(dt) 
  if currentTrack and not backgroundMus[currentTrack]:isPlaying() then
    playRandomTrack(currentTrack)
  end

  -- start menu
  if gameState == "start" then
    local wx, wy, wz = lovr.headset.getPosition("hand/right")
    local dx, dy, dz = lovr.headset.getDirection("hand/right")

    for _, btn in ipairs(startMenuButtons) do
      btn.pointingAt = false 
      -- get menu anchor relative to head
      local hx, hy, hz = lovr.headset.getPosition("head")
      local fx, _, fz = lovr.headset.getDirection("head")
      local forward = lovr.math.newVec3(fx, 0, fz):normalize()
      local menuX = hx + forward.x * 1
      local menuY = hy
      local menuZ = hz + forward.z * 1
      local bx = menuX + btn.x
      local by = menuY + btn.y
      local bz = menuZ + btn.z

      local rayLength = 3

      -- vector from ray origin to button
      local v = lovr.math.newVec3(bx - wx, by - wy, bz - wz)
      local dir = lovr.math.newVec3(dx, dy, dz)
      dir:normalize()
      
      -- project v onto ray
      local t = v:dot(dir)
      t = math.max(0, math.min(rayLength, t)) -- clamp to ray segment
      
      local closest = lovr.math.newVec3(wx, wy, wz) + dir * t
      local dist = (lovr.math.newVec3(bx, by, bz) - closest):length()

      -- button box half-extents
      local halfW, halfH, halfD = buttonSize.w / 2, buttonSize.h / 2, buttonSize.d / 2

      -- check if closest point is inside the box
      btn.pointingAt =
        math.abs(closest.x - bx) < halfW and
        math.abs(closest.y - by) < halfH and
        math.abs(closest.z - bz) < halfD
      if btn.pointingAt and lovr.headset.wasReleased("hand/right", "trigger") then
        if btn.id == "start" then
          gameState = "game"
        elseif btn.id == "settings" then
          previousGameState = gameState
          gameState = "settings"
        elseif btn.id == "quit" then
          lovr.event.quit()
        end
      end
    end
  elseif gameState == "settings" then
    local wx, wy, wz = lovr.headset.getPosition("hand/right")
    local dx, dy, dz = lovr.headset.getDirection("hand/right")

    for _, btn in ipairs(settingsMenuButtons) do
      btn.pointingAt = false
      -- get menu anchor relative to head
      local hx, hy, hz = lovr.headset.getPosition("head")
      local fx, _, fz = lovr.headset.getDirection("head")
      local forward = lovr.math.newVec3(fx, 0, fz):normalize()
      local menuX = hx + forward.x * 1
      local menuY = hy
      local menuZ = hz + forward.z * 1
      local bx = menuX + btn.x
      local by = menuY + btn.y
      local bz = menuZ + btn.z

      local rayLength = 3

      -- vector from ray origin to button
      local v = lovr.math.newVec3(bx - wx, by - wy, bz - wz)
      local dir = lovr.math.newVec3(dx, dy, dz)
      dir:normalize()

      -- project v onto ray
      local t = v:dot(dir)
      t = math.max(0, math.min(rayLength, t)) -- clamp to ray segment
      
      local closest = lovr.math.newVec3(wx, wy, wz) + dir * t
      local dist = (lovr.math.newVec3(bx, by, bz) - closest):length()

      -- button box half-extents
      local halfW, halfH, halfD = buttonSize.w / 2, buttonSize.h / 2, buttonSize.d / 2

      -- check if closest point is inside the box
      btn.pointingAt =
        math.abs(closest.x - bx) < halfW and
        math.abs(closest.y - by) < halfH and
        math.abs(closest.z - bz) < halfD
      if btn.pointingAt then
        if btn.id == "volume" then
          if lovr.headset.wasReleased("hand/right", "trigger") then
            btn.isOn = not btn.isOn
            if btn.isOn then
              lovr.audio.setVolume(volume)
            end
          end
          if btn.isOn then 
            local dx, dy = lovr.headset.getAxis("hand/right", "thumbstick")
            local deadzone = 0.1
            local increaseRate = 0.02

            if math.abs(dy) > deadzone then
              if dy > deadzone then volume = volume + increaseRate end
              if dy < -deadzone then volume = volume - increaseRate end 

              if volume > 1 then volume = 1 end
              if volume < 0 then volume = 0 end

              btn.label = "Volume: " .. tostring(math.floor(volume * 100)) .. "%"
              lovr.audio.setVolume(volume)
            end 
          else
            lovr.audio.setVolume(0)
          end
        elseif btn.id == "hitbox" then
          if lovr.headset.wasReleased("hand/right", "trigger") then
            btn.isOn = not btn.isOn
          end
        elseif btn.id == "back" then
          if lovr.headset.wasReleased("hand/right", "trigger") then 
            gameState = previousGameState
            previousGameState = nil
          end 
        end
      end 
    end
  elseif gameState == "paused" then
    local wx, wy, wz = lovr.headset.getPosition("hand/right")
    local dx, dy, dz = lovr.headset.getDirection("hand/right")

    for _, btn in ipairs(settingsMenuButtons) do
      btn.pointingAt = false
      -- get menu anchor relative to head
      local hx, hy, hz = lovr.headset.getPosition("head")
      local fx, _, fz = lovr.headset.getDirection("head")
      local forward = lovr.math.newVec3(fx, 0, fz):normalize()
      local menuX = hx + forward.x * 1
      local menuY = hy
      local menuZ = hz + forward.z * 1
      local bx = menuX + btn.x
      local by = menuY + btn.y
      local bz = menuZ + btn.z

      local rayLength = 3

      -- vector from ray origin to button
      local v = lovr.math.newVec3(bx - wx, by - wy, bz - wz)
      local dir = lovr.math.newVec3(dx, dy, dz)
      dir:normalize()

      -- project v onto ray
      local t = v:dot(dir)
      t = math.max(0, math.min(rayLength, t)) -- clamp to ray segment
      
      local closest = lovr.math.newVec3(wx, wy, wz) + dir * t
      local dist = (lovr.math.newVec3(bx, by, bz) - closest):length()

      -- button box half-extents
      local halfW, halfH, halfD = buttonSize.w / 2, buttonSize.h / 2, buttonSize.d / 2

      -- check if closest point is inside the box
      btn.pointingAt =
        math.abs(closest.x - bx) < halfW and
        math.abs(closest.y - by) < halfH and
        math.abs(closest.z - bz) < halfD

      if lovr.headset.wasPressed("hand/left", "y") then
        gameState = "game"
      end 

      if btn.pointingAt and lovr.headset.wasReleased("hand/right", "trigger") then
        if btn.id == "unpause" then
          gameState = "game"
        elseif btn.id == "settings" then
          previousGameState = gameState
          gameState = "settings"
        elseif btn.id == "titlescreen" then
          for _, c in ipairs(objects) do
            c.col:destroy()
          end
          objects = {}
          gameState = "start"
        end
      end
    end 
  end

  if gameState ~= "game" then return end 

  world:update(dt)

  local dx, dy = lovr.headset.getAxis("hand/left", "thumbstick")
  local speed, deadzone = 2, 0.1

  if math.abs(dx) > deadzone or math.abs(dy) > deadzone then
    local hx, _, hz = lovr.headset.getDirection("head")
    local forward = lovr.math.newVec3(hx, 0, hz)
    if forward:length() < 1e-6 then forward:set(0,0,-1) end
    forward:normalize()

    local up = lovr.math.newVec3(0,1,0)
    local right = up:cross(forward)
    right:normalize()

    local forwardInput = dy
    local rightInput = -dx

    local move = forward * forwardInput + right * rightInput
    player.x = player.x + move.x * speed * dt
    player.z = player.z + move.z * speed * dt
  end

   -- update hand positions
  for handName, hand in pairs(hands) do
    local hx, hy, hz = lovr.headset.getPosition("hand/" .. handName)
    local worldX, worldY, worldZ = player.x + hx, player.y + hy, player.z + hz
    local newPos = lovr.math.newVec3(worldX, worldY, worldZ)

    -- compute velocity (for throw)
    hand.velocity = (newPos - hand.lastPos) / dt
    hand.lastPos:set(newPos:unpack())

    hand.col:setPosition(newPos:unpack())

    local gripping = lovr.headset.isDown("hand/" .. handName, "grip")

    if gripping and not hand.held then
      -- try to grab nearest cube
      for _, c in ipairs(objects) do
        local cx, cy, cz = c.col:getPosition()
        local dx, dy, dz = cx - worldX, cy - worldY, cz - worldZ
        if dx*dx + dy*dy + dz*dz < 0.3*0.3 then
          hand.held = c
          c.col:setKinematic(true) -- follow hand
          break
        end
      end
    elseif not gripping and hand.held then
      hand.held.col:setKinematic(false)
      hand.held.col:setLinearVelocity((hand.velocity * 3):unpack()) -- stronger throw
      hand.held.col:setAngularVelocity(
        math.random(-2, 2),
        math.random(-2, 2),
        math.random(-2, 2)
      )
      hand.held = nil
    end


    -- if holding, sync cube with hand
    if hand.held then
      hand.held.col:setPosition(newPos:unpack())
    end
  end

  if lovr.headset.wasPressed("hand/right", "b") then
    shapeIndex = shapeIndex + 1
    if shapeIndex > #shapes then
      shapeIndex = 1
    end 
  end

  if lovr.headset.wasPressed("hand/left", "y") then
    gameState = "paused"
  end

  if lovr.headset.isDown("hand/right", "trigger") then
      local hx, hy, hz = lovr.headset.getPosition("hand/right")
      local wx, wy, wz = player.x + hx, player.y + hy, player.z + hz
      if shapes[shapeIndex] == "cubes" then
        local size = .3
        local col = spawnCube(wx, wy, wz, size)
        table.insert(objects, {
          type = "cube",
          pos = lovr.math.newVec3(wx, wy, wz - .5),
          size = size,
          color = { math.random(), math.random(), math.random() },
          col = col,
        })
      elseif shapes[shapeIndex] == "spheres" then
        local size = .3
        local col = spawnSphere(wx, wy, wz, size)
        table.insert(objects, {
          type = "sphere",
          pos = lovr.math.newVec3(wx, wy, wz - .5),
          size = size,
          color = { math.random(), math.random(), math.random() },
          col = col,
        })
      elseif shapes[shapeIndex] == "yv" then
        local size = .3
        local col = spawnCube(wx, wy, wz, size)
        table.insert(objects, {
          type = "yv",
          pos = lovr.math.newVec3(wx, wy, wz - .5),
          size = size,
          color = { math.random(), math.random(), math.random() },
          col = col,
        })
      elseif shapes[shapeIndex] == "the knight" then
        local size = .3
        local col = spawnCube(wx, wy, wz, size)
        table.insert(objects, {
          type = "the knight",
          pos = lovr.math.newVec3(wx, wy, wz - .5),
          size = size,
          color = { math.random(), math.random(), math.random() },
          col = col,
        })
      elseif shapes[shapeIndex] == "hornet" then
        local size = .3
        local col = spawnCube(wx, wy, wz, size)
        table.insert(objects, {
          type = "hornet",
          pos = lovr.math.newVec3(wx, wy, wz - .5),
          size = size,
          color = { math.random(), math.random(), math.random() },
          col = col,
        })
      elseif shapes[shapeIndex] == "wheatley" then
        local size = .025
        local col = spawnSphere(wx, wy, wz, size)
        table.insert(objects, {
          type = "wheatley",
          pos = lovr.math.newVec3(wx, wy, wz - .5),
          size = size,
          color = { math.random(), math.random(), math.random() },
          col = col,
        })
      end
  end   

  if lovr.headset.isDown("hand/left", "trigger") then 
      local hx, hy, hz = lovr.headset.getPosition("hand/left")
      local dx, dy, dz = lovr.headset.getDirection("hand/left")
      local wx, wy, wz = player.x + hx + dx * 0.3, player.y + hy + dy * 0.3, player.z + hz + dz * 0.3
      if shapes[shapeIndex] == "cubes" then
        local size = .3
        local col = spawnCube(wx, wy, wz, size)
        table.insert(objects, {
          type = "cube",
          pos = lovr.math.newVec3(wx, wy, wz - .5),
          size = size,
          color = { math.random(), math.random(), math.random() },
          col = col,
        })
      elseif shapes[shapeIndex] == "spheres" then
        local size = .3
        local col = spawnSphere(wx, wy, wz, size)
        table.insert(objects, {
          type = "sphere",
          pos = lovr.math.newVec3(wx, wy, wz - .5),
          size = size,
          color = { math.random(), math.random(), math.random() },
          col = col,
        })
      elseif shapes[shapeIndex] == "yv" then
        local size = .3
        local col = spawnCube(wx, wy, wz, size)
        table.insert(objects, {
          type = "yv",
          pos = lovr.math.newVec3(wx, wy, wz - .5),
          size = size,
          color = { math.random(), math.random(), math.random() },
          col = col,
        })
      elseif shapes[shapeIndex] == "the knight" then
        local size = .3
        local col = spawnCube(wx, wy, wz, size)
        table.insert(objects, {
          type = "the knight",
          pos = lovr.math.newVec3(wx, wy, wz - .5),
          size = size,
          color = { math.random(), math.random(), math.random() },
          col = col,
        })
      elseif shapes[shapeIndex] == "hornet" then
        local size = .2
        local col = spawnCube(wx, wy, wz, size)
        table.insert(objects, {
          type = "hornet",
          pos = lovr.math.newVec3(wx, wy, wz - .5),
          size = size,
          color = { math.random(), math.random(), math.random() },
          col = col,
        })
      elseif shapes[shapeIndex] == "wheatley" then
        local size = .025
        local col = spawnSphere(wx, wy, wz, size)
        table.insert(objects, {
          type = "wheatley",
          pos = lovr.math.newVec3(wx, wy, wz - .5),
          size = size,
          color = { math.random(), math.random(), math.random() },
          col = col,
        })
      end
  end

  if lovr.headset.isDown("hand/right", "a") then
    for _, c in ipairs(objects) do
      c.col:destroy()
    end
    objects = {}
  end
end 

function lovr.draw(pass)
  if gameState == "start" then
    drawStartMenu(pass)
  elseif gameState == "settings" then
    drawSettingsMenu(pass)
  elseif gameState == "game" then
    pass:translate(-player.x, -player.y, -player.z)

    -- draw floor
    local fx, fy, fz = floor.col:getPosition()
    local angle, ax, ay, az = floor.col:getOrientation()
    pass:setColor(floor.color)
    pass:cube(fx, fy, fz, floor.size:unpack(), angle, ax, ay, az)

    -- Draw objects
    for _, c in ipairs(objects) do
      local x, y, z = c.col:getPosition()
      local angle, ax, ay, az = c.col:getOrientation()
      if c.type == "cube" then 
        pass:setColor(c.color)
        pass:cube(x, y, z, c.size, angle, ax, ay, az)
      elseif c.type == "sphere" then 
        pass:setColor(c.color)
        pass:sphere(x, y, z, c.size)
      elseif c.type == "yv" then
        pass:setColor(1,1,1)
        pass:draw(yvModel, x, y, z, c.size / 100, angle)
      elseif c.type == "the knight" then
        pass:setColor(1,1,1)
        pass:draw(knightModel, x, y, z, c.size / 50, angle)
      elseif c.type == "hornet" then
        pass:setColor(1,1,1)
        pass:draw(hornetModel, x, y, z, c.size / 2.5, angle)
      elseif c.type == "wheatley" then
        pass:setColor(1,1,1)
        pass:draw(wheatleyModel, x, y, z, c.size / 5, angle)
      end 
    end

    -- draw hands (as spheres)
    pass:setColor(0, 0, 1) -- left hand
    local lx, ly, lz = hands.left.col:getPosition()
    pass:sphere(lx, ly, lz, 0.1)

    pass:setColor(0, 1, 0) -- right hand
    local rx, ry, rz = hands.right.col:getPosition()
    pass:sphere(rx, ry, rz, 0.1)

    -- shape Indicator
    drawShapeIndicator(pass)

    pass:setColor(1,1,1)
    local randAngle = lovr.headset.getTime()
    pass:text(shapes[shapeIndex], rx, ry + 0.15, rz, 0.05, randAngle)

    if settingsMenuButtons[2].isOn then
      for _, collider in ipairs(world:getColliders()) do
        if collider == floor.col then return end

        local shape = collider:getShapes()[1]  -- collider may have multiple shapes
        local x, y, z = collider:getPosition()
        local angle, ax, ay, az = collider:getOrientation()

        if shape:getType() == 'box' then
          local sx, sy, sz = shape:getDimensions()
          pass:setColor(1, 0, 0) -- red
          pass:cube(x, y, z, sx, angle, ax, ay, az)
        elseif shape:getType() == 'sphere' then
          local radius = shape:getRadius()
          pass:setColor(0, 1, 0) -- green
          pass:sphere(x, y, z, radius)
        end
      end
    end
    pass:setColor(1,1,1)
  end 
end