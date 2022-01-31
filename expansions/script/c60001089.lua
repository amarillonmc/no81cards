local m=60001089
local cm=_G["c"..m]
cm.name="闪术兵器-赤雷"
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,60001089+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.acespcon)
	e1:SetValue(cm.hspval)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.remcost)
	e2:SetTarget(cm.remtg)
	e2:SetOperation(cm.remop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsSetCard(0x1115) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.acespcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local zone=0
	local lg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and ft>=1
end
function cm.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return 0,zone
end
function cm.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	local seq=c:GetSequence()+1
	local zone=c:GetColumnZone(LOCATION_ONFIELD,tp)
	e:SetLabel(seq)
	Duel.SetTargetParam(zone)
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e1:SetLabelObject(c)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCountLimit(1)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel()
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.wfilter(c,tp,seq,zone)
	return (bit.band(zone,c:GetColumnZone(LOCATION_ONFIELD,tp))~=0 or (c:GetSequence()==seq and c:GetControler()==tp)) and c:IsAbleToHand()
end
function cm.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local seq=e:GetLabel()
	local zone=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if seq==0 then
		seq=e:GetHandler():GetSequence()
		zone=e:GetHandler():GetColumnZone(LOCATION_ONFIELD,tp)
	end
	if seq~=0 then
		seq=e:GetLabel()-1
	end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.wfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp,seq,zone) end
	local g=Duel.GetMatchingGroup(cm.wfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,seq,zone)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()-1
	local zone=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.wfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,seq,zone)
	if g:GetCount()~=0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	e:SetLabel(0)
end