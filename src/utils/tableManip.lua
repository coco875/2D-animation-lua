function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function has_value(tab, val)
   for index, value in ipairs(tab) do
       if value == val then
           return true
       end
   end

   return false
end

function has_comon_element(tab1, tab2)
   for i, v in ipairs(tab1) do
       if has_value(tab2, v) then
           return true
       end
   end

   return false
end