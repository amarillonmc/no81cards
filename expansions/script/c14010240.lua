--存在坍塌
local m=14010240
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.xfilter(c,e,tp)
	return (c:IsControler(tp) or c:IsAbleToChangeControler()) and (not e or not c:IsImmuneToEffect(e)) and not c:IsType(TYPE_TOKEN)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,nil,tp) end
	local sg=Duel.GetMatchingGroup(cm.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,#sg,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Group.CreateGroup()
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_ONFIELD) then
		sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	else
		sg=Duel.GetMatchingGroup(cm.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	end
	local tc=sg:GetFirst()
	while tc do
		local og=tc:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		tc=sg:GetNext()
	end
	if Duel.Overlay(c,sg)~=0 then
		local og=c:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
	end
end