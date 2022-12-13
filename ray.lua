Ray = {}
Ray.__index = Ray

function Ray:create(origin, to)
    local ray = {}
    setmetatable(ray, Ray)
    ray.origin = origin
    ray.to = origin
    ray.intersects = {}
    ray.closest = nil
    ray.cs      = {}
    return ray
end

function Ray:draw()
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 1, 0)
    local to = self.to
    if (self.closest ~= nil) then
        to = {self.closest.x, self.closest.y}
    end
    -- love.graphics.line(self.origin[1], self.origin[2], to[1], to[2])

    for i=1, #self.intersects do
        local intersect = self.intersects[i]
        love.graphics.circle("fill", intersect.x, intersect.y, 5)
    end
    if (self.closest ~= nil) then
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("line", self.closest.x, self.closest.y, 7)
    end

    love.graphics.setColor(r, g, b, a)
end

function Ray:lineTo(to, segments)
    self.to = to
    local intersects = {}
    self.closest = nil
    for i=1, #segments do
        local intersect = self:intersection(segments[i])
        if (intersect ~= nil) then
            table.insert(intersects, intersect)
            if (self.closest == nil) then
                self.closest = intersect
                self.cs = segments[i][3]
            else
                if (intersect.t1 < self.closest.t1) then
                    self.closest = intersect
                    self.cs      = segments[i][3]
                end
            end
        end
    end
    if (self.cs) then
        Obstacles[self.cs].visible = true
    end
    self.intersects = intersects
end

function Ray:intersection(segment)    
    local px = self.origin[1]
    local py = self.origin[2]
    local dx = self.to[1] - px
    local dy = self.to[2] - py

    local spx = segment[1][1]
    local spy = segment[1][2]
    local sdx = segment[2][1] - spx
    local sdy = segment[2][2] - spy

    local rmag = math.sqrt(dx * dx + dy * dy)
    local smag = math.sqrt(sdx * sdx + sdy * sdy)

    if (dx / rmag == sdx / smag) and (dy / smag == sdy / smag) then
        return nil
    end

    -- What? Did you really expect me to do it right way?!
    if (dx == 0) then
        dx = 0.000005
    end

    local t2 = (dx * (spy - py) + dy * (px - spx)) / (sdx * dy - sdy * dx)
    local t1 = (spx + sdx * t2 - px) / dx

    if (t1 < 0) then
        return nil
    end

    if (t2 < 0 or t2 > 1) then
        return nil
    end

    local x = px + dx * t1
    local y = py + dy * t1
    return {x = x, y = y, t1 = t1}
end