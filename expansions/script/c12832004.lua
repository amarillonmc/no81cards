--春樱之歌
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12832001,12832003)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.actcost)
	e1:SetTarget(s.acttg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(s.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(s.effectfilter)
	c:RegisterEffect(e3)
end
function s.acfilter(c,ec)
	return (c:IsFaceup() and c:IsCode(12832003) and c:IsAbleToGraveAsCost()) 
		or (c:IsFaceupEx() and c:IsCode(12832007) and c:IsAbleToExtraAsCost()
		and ec:GetFlagEffect(12832007)~=0)
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.acfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.acfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e:GetHandler())
	if g:GetFirst():IsCode(12832007) then
		Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_COST)
	else
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(s.disop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tc~=e:GetHandler() and bit.band(loc,LOCATION_ONFIELD)~=0
		and Duel.IsChainNegatable(ev) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev,true)
	end
end
function s.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and (te:GetHandler():IsCode(12832001) or aux.IsCodeListed(te:GetHandler(),12832001)) and te:IsActiveType(TYPE_MONSTER) and bit.band(loc,LOCATION_ONFIELD)~=0
end