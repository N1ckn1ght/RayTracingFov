require("vector")
require("obstacle")
require("ray")
require("radiant")
require("radiantunique")
require("vision")

function love.load()
    Width = love.graphics.getWidth()
    Height = love.graphics.getHeight()

    Obstacles = {
        Obstacle:create({{0, 0}, {Width, 0}, {Width, Height}, {0, Height}, {0, 0}}),
        Obstacle:create({{100, 100}, {100, 200}, {200, 200}, {200, 100}, {100, 100}}),
        Obstacle:create({{500, 100}, {650, 100}, {650, 300}, {500, 100}}),
        Obstacle:create({{450, 400}, {650, 500}, {480, 600}, {380, 420}, {450, 400}}),
        Obstacle:create({{390, 520}, {390, 570}, {340, 570}, {340, 520}, {390, 520}}),
        Obstacle:create({{80, 300}, {140, 300}, {140, 470}, {120, 470}, {80, 300}})}

    Segments = {}
    for i=1, #Obstacles do
        local points = Obstacles[i].points
        for j=2, #points do
            table.insert(Segments, {points[j-1], points[j], i})
        end
    end

    Vision = Vision:create(Width / 2, Height / 2, 30)
end

function love.update(dt) 
    for i=1, #Obstacles do
        Obstacles[i]:update()
    end

    local x, y = love.mouse.getPosition()
    Vision:update(x, y)
    -- ray:lineTo({x, y}, segments)
    -- radiant:update(segments)
end

function love.draw()
    for i=1, #Obstacles do
        Obstacles[i]:draw()
    end
    Vision:draw()
end