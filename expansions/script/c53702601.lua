if AD_Database_3 then return end
AD_Database_3=true
SNNM=SNNM or {}
local s=SNNM
function s.LostLink(c)
	if AD_LostLink_check then return end
	AD_LostLink_check=true
	local markers={0x1,0x2,0x4,0x8,0x20,0x40,0x80,0x100}
	Card.GetLink=function(sc)
		return s.NumNumber(sc:GetLinkMarker(),markers)
	end
	Card.IsLink=function(sc,...)
		local t={...}
		for _,v in ipairs(t) do if s.NumNumber(sc:GetLinkMarker(),markers)==v then return true end end
		return false
	end
	Card.IsLinkAbove=function(sc,link)
		if s.NumNumber(sc:GetLinkMarker(),markers)>=link then return true else return false end
	end
	Card.IsLinkBelow=function(sc,link)
		if s.NumNumber(sc:GetLinkMarker(),markers)<=link then return true else return false end
	end
end
function s.NumNumber(a,hex_numbers)
	local count = 0
	for _, num in ipairs(hex_numbers) do
		if bit.band(a, num) ~= 0 then
			count = count + 1
		end
	end
	return count
end
