local m=31422004
local cm=_G["c"..m]
cm.name="创世万感-『言叶之酒』"
if not pcall(function() require("expansions/script/c31422000") end) then require("expansions/script/c31422000") end
function cm.initial_effect(c)
	Seine_wangan.equip_enable(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetValue(cm.valcon)
	c:RegisterEffect(e1)
end
function cm.valcon(e,re,r,rp)
	local c=e:GetHandler()
	local con1=c:GetFlagEffect(m)<c:GetEquipTarget():GetEquipCount()
	local con2=bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
	local res=con1 and con2
	if res then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
		return true
	else
		return false
	end
end