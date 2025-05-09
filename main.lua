
local triangles = {}
local mouseWasDown = false
local mWasDown = false
local nWasDown = false

local showDots = true
local currColor = {1,1,1}

function love.draw()

    for i=1,#triangles do
        if #triangles[i] >= 6 then
            love.graphics.setColor(currColor[1], currColor[2], currColor[3])
            love.graphics.polygon("fill", triangles[i])
        end

        if showDots then
            love.graphics.setColor(1, 1, 1)
            for u=1,#triangles[i]/2 do
                love.graphics.circle("fill", triangles[i][2*u-1], triangles[i][2*u], 3)
            end
        end
    end

    if love.mouse.isDown(1) and not mouseWasDown then
        if not triangles[#triangles] or #triangles[#triangles] == 6 then
            -- if there is nothing on screen or the last triangle is complete, make a new triangle
            triangles[#triangles+1] = {love.mouse.getX(), love.mouse.getY()}
        else
            -- otherwise add a vertex to the current triangle
            triangles[#triangles][#triangles[#triangles]+1] = love.mouse.getX()
            triangles[#triangles][#triangles[#triangles]+1] = love.mouse.getY()
        end
    end

    if love.keyboard.isDown('m') and not mWasDown then
        showDots = not showDots
    end

    if love.keyboard.isDown('n') then
        -- show color selector
        local width, height = love.graphics.getDimensions()

        for u = 0,width-1 do
            for v = 0,height-1 do
                local slices = 100
                local blockWidth = (width-1)/slices
                love.graphics.setColor((u%blockWidth)/(blockWidth-1), v/(height-1), u/blockWidth/slices)
                love.graphics.rectangle("fill", u, v, 1, 1)
            end
        end
    end

    if not love.keyboard.isDown('n') and nWasDown then
        local width, height = love.graphics.getDimensions()
        local u = love.mouse.getX()
        local v = love.mouse.getY()
        local slices = 100
        local blockWidth = (width-1)/slices
        currColor = {(u%blockWidth)/(blockWidth-1), v/(height-1), u/blockWidth/slices}
    end

    mouseWasDown = love.mouse.isDown(1)
    mWasDown = love.keyboard.isDown('m')
    nWasDown = love.keyboard.isDown('n')
end