local m=53722003
local cm=_G["c"..m]
cm.name="大祭环 祗芭"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.GreatCircle(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.inmop1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetLabelObject(e3)
	e4:SetOperation(cm.inmop2)
	c:RegisterEffect(e4)
end
cm[0]=0
function cm.inmop1(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3531))
	e1:SetValue(cm.efilter)
	e1:SetLabelObject(re)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	e:SetLabelObject(e1)
end
function cm.inmop2(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	local cg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	local g,id=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS,CHAININFO_CHAIN_ID)
	if #cg>0 and not cg:IsExists(function(c)return not c:IsSetCard(0x3531)end,1,nil) and id~=cm[0] and ((not g) or (not g:IsExists(function(c,tp)return c:IsControler(tp) and c:IsOnField()end,1,nil,tp))) and Duel.IsPlayerCanDiscardDeck(tp,1) then
		cm[0]=id
		Duel.Hint(HINT_CARD,0,m)
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
	else e:GetLabelObject():GetLabelObject():Reset() end
end
function cm.efilter(e,re)
	return re==e:GetLabelObject()
end
