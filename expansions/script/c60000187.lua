--执铭化刃
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000179)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,1))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(cm.adcost)
	e2:SetTarget(cm.adtg)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.confil(c,tp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,3,nil,c:GetCode())
end
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confil,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,e:GetHandlerPlayer())
end
function cm.costfil(c)
	return c:IsCode(m) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfil,e:GetHandlerPlayer(),LOCATION_HAND+LOCATION_DECK,0,2,nil) end
	local num=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(cm.costfil,e:GetHandlerPlayer(),LOCATION_HAND+LOCATION_DECK,0,nil):Select(e:GetHandlerPlayer(),2,2,nil)
	for tc in aux.Next(g) do
		if tc:IsLocation(LOCATION_HAND) then num=num+1 end
	end
	if Duel.SendtoGrave(g,REASON_COST)~=0 and num~=0 then Duel.Draw(tp,num,REASON_COST) end
end
function cm.efil(c,tp)
	return aux.IsCodeListed(c,60000179) and Duel.IsExistingMatchingCard(cm.gfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.gfil(c,code)
	return c:IsCode(code) and c:IsAbleToGrave()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.efil,tp,LOCATION_GRAVE,0,nil,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.GetMatchingGroup(cm.gfil,tp,LOCATION_HAND+LOCATION_DECK,0,nil,sg:GetFirst():GetFirst()):Select(tp,1,2,nil)
		local num=0
		for tc in aux.Next(tg) do
			if tc:IsLocation(LOCATION_HAND) then num=num+1 end
		end
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and num~=0 then Duel.Draw(tp,num,REASON_EFFECT) end
	end
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(e:GetHandlerPlayer(),LOCATION_MZONE,0,0x62b)>0 end
	Duel.RemoveCounter(e:GetHandlerPlayer(),LOCATION_MZONE,0,0x62b,1,REASON_COST)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.efil,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end



















