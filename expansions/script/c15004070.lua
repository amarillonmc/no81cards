local m=15004070
local cm=_G["c"..m]
cm.name="炽红之刃的荒仙·舒华拉"
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,15004070+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.hspcon)
	e1:SetValue(cm.hspval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1,15004071)
	e2:SetCost(cm.descost)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsSetCard(0x9f3e)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,0,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function cm.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,0,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return 0,zone
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.descon)
	e1:SetOperation(cm.desop)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetLabelObject(e:GetHandler())
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()+1 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(nil,1-tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectEffectYesNo(tp,e:GetLabelObject(),aux.Stringid(m,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local ag=Duel.SelectMatchingCard(tp,nil,1-tp,LOCATION_ONFIELD,0,1,1,nil)
	g:Merge(ag)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end