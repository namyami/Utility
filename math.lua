local _math = {};
local pi = 3.1415926535897931;

_math.to_orientation = function(origin_position: Vector3, end_position: Vector3): Vector3
	local direction = (end_position - origin_position).Unit;
	local pitch = (math.atan2(end_position.Y - origin_position.Y, math.sqrt((end_position.X - origin_position.X) ^ 2) + (end_position.Z - origin_position.Z) ^ 2));
	local yaw = math.atan2(-direction.X, -direction.Z);

	return Vector3.new(math.deg(pitch), math.deg(yaw), 0); -- pitch, yaw
end

_math.calculate_vertices = function(offset: Vector3, root: number): any
	local vertices = {};
	if (not root) then
		root = 4;
	end

	for t = 0, pi, (pi / root) do
		for p = 0, (2 * pi), root do
			table.insert(vertices, Vector3.new(math.sin(t) * math.cos(p) * offset.X, (math.cos(t) * offset.Y), math.sin(t) * math.sin(p) * offset.Z));
		end
	end

	return vertices;
end

_math.line_rotation = function(from, to, thickness, gui_service) -- we only pass guiservice here cuz some games may detect referencing it, so cloneref if you need
	local gui_inset = gui_service:GetGuiInset();

	local start_pos = Vector2.new(from.X - gui_inset.X,from.Y - gui_inset.Y);
	local end_pos = Vector2.new(to.X - gui_inset.X, to.Y - gui_inset.Y);

	local direction = end_pos - start_pos;
	local center = (start_pos + end_pos) * 0.5; -- make sure .5 is your anchorpoint on x axis (both x and y work fine)
	
	return UDim2.fromOffset(center.X, center.Y), math.deg(math.atan2(direction.Y, direction.X)), UDim2.fromOffset(direction.Magnitude, thickness);
end

return _math;
