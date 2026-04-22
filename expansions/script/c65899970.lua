-- 有求必应屋
local s,id,o=GetID()
function s.initial_effect(c)
	--增加海燕卡名
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetRange(0xff)
	e0:SetValue(11451631)
	c:RegisterEffect(e0)
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
	local old_AddCodeList = aux.AddCodeList
	function aux.AddCodeList(c, ...)
    	local args = { ... }
    	local new_args = {}
    	for _, code in ipairs(args) do
       	 table.insert(new_args, code)
       	 local ctype = Duel.ReadCard(code, CARDDATA_TYPE)
       	 if ctype and bit.band(ctype, TYPE_FIELD) ~= 0 then
           	 local already = false
           	 for _, v in ipairs(new_args) do
            	    if v == id then already = true; break end
          	  end
        	    if not already then
      	          table.insert(new_args, id)
    	        end
  	      end
	    end
  	  old_AddCodeList(c, table.unpack(new_args))
	end
end