--可可莉柯特·兽耳布偶
local m=33310103
local cm=_G["c"..m]
cm.rssetcode="Cochrot"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--summon success
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.limitop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetOperation(cm.limitop2)
	c:RegisterEffect(e5)--]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(cm.actcon)
	c:RegisterEffect(e2)
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_REMOVE)
	e6:SetCountLimit(1,m+100)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetTarget(cm.thtg)
	e6:SetOperation(cm.thop2)
	c:RegisterEffect(e6)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.thfilter(c)
	return c:IsCode(33310102) and c:IsAbleToHand()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g<=0 or Duel.SendtoHand(g,nil,REASON_EFFECT)<=0 then return end
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,0,LOCATION_GRAVE,nil,e,tp)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			if Duel.SpecialSummonStep(sc,0,tp,1-tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function cm.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function cm.limitop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter,1,nil,tp) then
		Duel.SetChainLimitTillChainEnd(cm.chlimit)
	end
end
function cm.cfilter2(c,tp)
	return c:GetOwner()~=tp and c:IsType(TYPE_MONSTER)
end
function cm.limitop2(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter2,1,nil,tp) then
		Duel.SetChainLimitTillChainEnd(cm.chlimit)
	end
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.thfilter2(c)
	return c:IsAbleToHand() and c:GetType()&0x82==0x82
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop2(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function cm.actcon(e,re)
	local tp=e:GetHandlerPlayer()
	local rc=re:GetHandler()
	local b1,eg1=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
	local b2,eg2=Duel.CheckEvent(EVENT_FLIP_SUMMON_SUCCESS,true)
	local b3,eg3=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	local b4,eg4=Duel.CheckEvent(EVENT_TO_GRAVE,true)
	local event=(b1 and eg1:IsExists(cm.cfilter,1,nil,tp)) or (b2 and eg2:IsExists(cm.cfilter,1,nil,tp)) or (b3 and eg3:IsExists(cm.cfilter,1,nil,tp)) or (b4 and eg4:IsExists(cm.cfilter2,1,nil,tp))
	local ev=Duel.GetCurrentChain()
	local trigger=re:GetType()&(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FLIP)~=0 and (not rc:IsLocation(LOCATION_HAND) or rc:IsPublic())
	return event and (ev==0 or trigger)
end