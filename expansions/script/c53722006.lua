local m=53722006
local cm=_G["c"..m]
cm.name="大祭环 毘舎闍"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.GreatCircle(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.acop)
	c:RegisterEffect(e3)
end
function cm.cfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) and c:IsType(TYPE_MONSTER)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local rec=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*200
	if eg:IsExists(cm.cfilter,1,nil) and rec>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Recover(tp,rec,REASON_EFFECT)
	end
end
