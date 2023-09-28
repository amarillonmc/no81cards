local m=53705002
local cm=_G["c"..m]
cm.name="幻海袭 宝藏"
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
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
end
function cm.pubfilter(c)
	return c:IsSetCard(0x3534) and c:IsPublic()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsPublic() then return end
	if Duel.IsExistingMatchingCard(cm.pubfilter,tp,LOCATION_HAND,0,1,c) then
		SNNM.SetPublic(c,3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		if Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	else SNNM.SetPublic(c,4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) end
end
