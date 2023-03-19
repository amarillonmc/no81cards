local m=53722003
local cm=_G["c"..m]
cm.name="大祭环 祗芭"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.GreatCircle(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3531))
	e1:SetCondition(cm.econ)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
end
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_GRAVE,0)
	return #g>0 and not g:IsExists(aux.NOT(Card.IsSetCard),1,nil,0x3531)
end
function cm.efilter(e,te)
	local tp=e:GetHandlerPlayer()
	if te:GetHandlerPlayer()==tp or not te:IsActivated() then return false end
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsExists(function(c,e,tp)return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x3531) and c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e)end,1,nil,e,tp)  then
		if Duel.GetFlagEffect(tp,m)==0 then
			Duel.RegisterFlagEffect(tp,m,0,0,0)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ADJUST)
			e1:SetOperation(cm.imcop)
			Duel.RegisterEffect(e1,tp)
		end
	else return false end
	return true
end
function cm.imcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	Duel.ResetFlagEffect(tp,m)
	e:Reset()
end 
