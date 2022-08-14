local m=31422010
local cm=_G["c"..m]
cm.name="创世万感-『深赤之岚』"
if not pcall(function() require("expansions/script/c31422000") end) then require("expansions/script/c31422000") end
function cm.initial_effect(c)
	Seine_wangan.equip_enable(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(cm.disval)
	c:RegisterEffect(e1)
end
function cm.disval(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=c:GetEquipTarget():GetEquipGroup()
	local zone=0
	g:ForEach(
		function (tc)
			if tc:IsSetCard(0x6316) then
				local p=tc:GetControler()
				local seq=tc:GetSequence()
				if p==tp then
					zone=bit.bor(zone,1<<(4-seq))
				else
					zone=bit.bor(zone,1<<seq)
				end
			end
		end
	)
	if tp==0 then
		zone=zone<<16
	end
	return zone
end