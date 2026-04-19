-- 有求必应屋
local s,id,o=GetID()
function s.initial_effect(c)
end
if not s.enable_all_field_code then
	s.enable_all_field_code=true
	s._is_code = Card.IsCode
	Card.IsCode = function(c, ...)
		local has_field = false
		for i = 1, select('#', ...) do
			local code = select(i, ...)
			local ctype = Duel.ReadCard(code, CARDDATA_TYPE)
			if ctype and bit.band(ctype, TYPE_FIELD) ~= 0 then
				has_field = true
				break
			end
		end
		if has_field then
			return c:IsOriginalCodeRule(id) or s._is_code(c, ...)
		else
			return s._is_code(c, ...)
		end
	end
	s._is_set_codelisted = aux.IsCodeListed
	aux.IsCodeListed = function(c, code)
		local is_field = false
		local ctype = Duel.ReadCard(code, CARDDATA_TYPE)
		if ctype and bit.band(ctype, TYPE_FIELD) ~= 0 then
			is_field = true
		end
   		if is_field then
			return c:IsOriginalCodeRule(id) or s._is_set_codelisted(c,code)
   		else
   			return s._is_set_codelisted(c, code)
		end
	end
	s._is_link_set_card = Card.IsLinkCode
	Card.IsLinkCode = function(c, ...)
		local has_field = false
		for i = 1, select('#', ...) do
			local code = select(i, ...)
			local ctype = Duel.ReadCard(code, CARDDATA_TYPE)
			if ctype and bit.band(ctype, TYPE_FIELD) ~= 0 then
				has_field = true
				break
			end
		end
		if has_field then
			return c:IsOriginalCodeRule(id) or s._is_link_set_card(c, ...)
		else
			return s._is_link_set_card(c, ...)
		end
	end
	s._is_fusion_set_card = Card.IsFusionCode
	Card.IsFusionCode = function(c, ...)
		local has_field = false
		for i = 1, select('#', ...) do
			local code = select(i, ...)
			local ctype = Duel.ReadCard(code, CARDDATA_TYPE)
			if ctype and bit.band(ctype, TYPE_FIELD) ~= 0 then
				has_field = true
				break
			end
		end
		if has_field then
			return c:IsOriginalCodeRule(id) or s._is_fusion_set_card(c, ...)
		else
			return s._is_fusion_set_card(c, ...)
		end
	end
end