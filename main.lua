-- Triangle renderer by Samy Bencherif 2025-05-08
-- filename: main.lua
-- to run: love .
-- dependencies: https://love2d.org/#download

local triangles = {}
local mouseWasDown = false
local mWasDown = false

local showDots = true
local currColor = {1,1,1}

function slice(arr, start, stop)
    -- return elements in the range [start, end] inclusive
    local out = {}
    for i=0,stop-start do
        out[i+1] = arr[start+i]
    end
    return out
end

function love.draw()

    for i=1,#triangles do
        if #triangles[i] >= 9 then
            love.graphics.setColor(slice(triangles[i], 1, 3))
            love.graphics.polygon("fill", slice(triangles[i], 4, #triangles[i]))
        end

        if showDots then
            love.graphics.setColor(1, 1, 1)
            for u=1,#slice(triangles[i], 4, #triangles[i])/2 do
                love.graphics.circle("fill", triangles[i][3+2*u-1], triangles[i][3+2*u], 3)
            end
        end
    end

    if love.mouse.isDown(1) and not mouseWasDown then
        if not triangles[#triangles] or #triangles[#triangles] == 9 then
            -- if there is nothing on screen or the last triangle is complete, start a new triangle
            triangles[#triangles+1] = {currColor[1], currColor[2], currColor[3], love.mouse.getX(), love.mouse.getY()}
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
        local slices, blockWidth

        for u = 0,width-1 do
            for v = 0,height-1 do
                slices = 100
                blockWidth = (width-1)/slices
                love.graphics.setColor((u%blockWidth)/(blockWidth-1), v/(height-1), u/blockWidth/slices)
                love.graphics.rectangle("fill", u, v, 1, 1)
            end
        end

        local u = love.mouse.getX()
        local v = love.mouse.getY()
        currColor = {(u%blockWidth)/(blockWidth-1), v/(height-1), u/blockWidth/slices}

        love.graphics.setColor(currColor[1], currColor[2], currColor[3])
        love.graphics.rectangle("fill", u-5, v-5, 10, 10)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", u-5, v-5, 10, 10)
    end

    mouseWasDown = love.mouse.isDown(1)
    mWasDown = love.keyboard.isDown('m')
end