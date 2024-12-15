local m=15005814
local cm=_G["c"..m]
cm.name="撒拉斐永·超越终结"
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsCode,15005812),nil,nil,aux.Tuner(aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT)),1,99)
	c:EnableReviveLimit()
	--up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(cm.atkval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
	--Select
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,m)
	e7:SetHintTiming(0,TIMING_END_PHASE)
	e7:SetTarget(cm.stg)
	e7:SetOperation(cm.sop)
	c:RegisterEffect(e7)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsPublic,c:GetControler(),LOCATION_HAND,0,nil)*500
end
function cm.oppofilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function cm.selffilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup() and c:IsAbleToHand()
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.oppofilter,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.selffilter,tp,LOCATION_ONFIELD,0,1,nil)
	if chk==0 then return e:GetHandler():IsAbleToExtra()
		and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function cm.pubfilter(c)
	return not c:IsPublic()
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_EXTRA) then
		if op==nil then
			local b1=Duel.IsExistingMatchingCard(cm.oppofilter,tp,0,LOCATION_ONFIELD,1,nil)
			local b2=Duel.IsExistingMatchingCard(cm.selffilter,tp,LOCATION_ONFIELD,0,1,nil)
			local chk=(b1 and b2 and Duel.IsExistingMatchingCard(Card.IsSummonLocation,tp,0,LOCATION_MZONE,1,nil,LOCATION_EXTRA))
			op=aux.SelectFromOptions(tp,
				{b1,aux.Stringid(m,1)},
				{b2,aux.Stringid(m,2)},
				{chk,aux.Stringid(m,3)})
		end
		if op==1 or op==3 then
			local sg=Duel.GetMatchingGroup(cm.oppofilter,tp,0,LOCATION_ONFIELD,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			if op==3 then Duel.BreakEffect() end
		end
		if op==2 or op==3 then
			local fg=Duel.GetMatchingGroup(cm.selffilter,tp,LOCATION_ONFIELD,0,nil)
			if Duel.SendtoHand(fg,nil,REASON_EFFECT)>0 then
				local pg=Duel.GetOperatedGroup():Filter(cm.pubfilter,nil)
				local pc=pg:GetFirst()
				while pc do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetDescription(66)
					e1:SetCode(EFFECT_PUBLIC)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
					pc:RegisterEffect(e1)
					pc=pg:GetNext()
				end
			end
		end
	end
end