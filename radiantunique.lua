RadiantUnique = {}
RadiantUnique.__index = RadiantUnique

function RadiantUnique:create(n)
    local radiant = {}
    setmetatable(radiant, RadiantUnique)
    radiant.n = n or 4
    radiant.position = {0, 0}
    radiant.dxdy = {}
    radiant.rays = {}
    radiant.unique = nil
    return radiant
end

function RadiantUnique:update(segments)
    if (self.unique == nil) then
        local unique = {}
        for i=1, #segments do
            local p1 = segments[i][1]
            local p2 = segments[i][2]
            local key1 = tostring(p1[1]) .. " " .. tostring(p1[2])
            local key2 = tostring(p2[1]) .. " " .. tostring(p2[2])
            if (unique[key1] == nil) then
                unique[key1] = p1
            end
            if (unique[key2] == nil) then
                unique[key2] = p2
            end
        end
        self.unique = {}
        local c = 1
        for k, v in pairs(unique) do
            self.unique[c] = v
            table.insert(self.rays, Ray:create(self.position, {0, 0}))
            table.insert(self.rays, Ray:create(self.position, {0, 0}))
            table.insert(self.rays, Ray:create(self.position, {0, 0}))
            c = c + 1
        end
    end
    x, y = love.mouse.getPosition()
    self.position[1] = x
    self.position[2] = y

    for i=1, #self.unique do
        local p = self.unique[i]
        local angle = math.atan2(p[2] - y, p[1] - x)
        local angles = {angle - 0.00001, angle, angle + 0.00001}
        for j=1, #angles do
            local dx = math.cos(angles[j])
            local dy = math.sin(angles[j])
            self.rays[(i - 1) * 3 + j]:lineTo({x+dx, y+dy}, segments)
            self.rays[(i - 1) * 3 + j].angle = angles[j]
        end
    end
end

function RadiantUnique:draw()
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.circle("fill", self.position[1], self.position[2], 5)
    table.sort(self.rays, function(a, b) return (a.angle - b.angle) < 0 end)
    local closest = {}
    for i, ray in ipairs(self.rays) do
        ray:draw()
        if (ray.closest ~= nil) then
            table.insert(closest, ray.closest.x)
            table.insert(closest, ray.closest.y)
        end
    end
    love.graphics.setLineWidth(3)
    love.graphics.polygon("line", closest)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(r, g, b, a)
end