local utils = {}

function utils.same_vector_type(a, b)
  return type(a) == type(b) and type(a) == "table" and a.type == b.type and a.size == b.size
end

function utils.print_table(t)
  local result = "{"
  for k, v in pairs(t) do
    if type(v) == "table" then
      result = result .. utils.print_table(v)
    else
      result = result .. k .. "=" .. v
    end
    result = result .. ", "
  end
  result = result .. "}"
  return result
end

return utils