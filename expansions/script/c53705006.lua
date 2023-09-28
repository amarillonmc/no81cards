local m=53705006
local cm=_G["c"..m]
cm.name="幻海袭 盗礼"
if not require and Duel.LoadScript then
    function require(str)
        local name=str
        for word in string.gmatch(str,"%w+") do
            name=word
        end
        Duel.LoadScript(name..".lua")
        return true
    end
end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.SeadowRover(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(cm.efftg)
	e3:SetOperation(cm.effop)
	c:RegisterEffect(e3)
end
function cm.pubfilter(c)
	return c:IsSetCard(0x3534) and c:IsPublic()
end
function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsPublic() then return end
	if Duel.IsExistingMatchingCard(cm.pubfilter,tp,LOCATION_HAND,0,1,c) then
		SNNM.SetPublic(c,3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		Duel.BreakEffect()
		local e5=Effect.CreateEffect(c)
		e5:SetCode(EFFECT_SEND_REPLACE)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetRange(LOCATION_HAND)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		e5:SetTarget(cm.reptarget)
		e5:SetOperation(cm.repoperation)
		c:RegisterEffect(e5)
	else SNNM.SetPublic(c,4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) end
end
function cm.reptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPublic() and c:GetDestination()==LOCATION_DECK end
	return true
end
function cm.repoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	c:ResetEffect(EFFECT_PUBLIC,RESET_CODE)
	SNNM.SetPublic(c,4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	e:Reset()
end
