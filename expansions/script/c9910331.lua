--神树勇者的庭院
function c9910331.initial_effect(c)
	c:EnableCounterPermit(0x956)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910331+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c9910331.efilter)
	c:RegisterEffect(e2)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c9910331.sumlimit)
	c:RegisterEffect(e3)
	--add counter
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c9910331.ctcost)
	e4:SetTarget(c9910331.cttg)
	e4:SetOperation(c9910331.ctop)
	c:RegisterEffect(e4)
	--1 counter
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9910331,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(c9910331.cost1)
	e5:SetTarget(c9910331.target1)
	e5:SetOperation(c9910331.operation1)
	c:RegisterEffect(e5)
	--3 counter
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9910331,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCost(c9910331.cost2)
	e6:SetTarget(c9910331.target2)
	e6:SetOperation(c9910331.operation2)
	c:RegisterEffect(e6)
	--5 counter
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(9910331,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCost(c9910331.cost3)
	e7:SetTarget(c9910331.target3)
	e7:SetOperation(c9910331.operation3)
	c:RegisterEffect(e7)
end
function c9910331.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9910331.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x956)
end
function c9910331.cfilter(c)
	return c:IsSetCard(0x956) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c9910331.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910331.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910331.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910331.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x956,1) end
end
function c9910331.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x956,1)
	end
end
function c9910331.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x956,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x956,1,REASON_COST)
end
function c9910331.filter1(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910331.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910331.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910331.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910331.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910331.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x956,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x956,3,REASON_COST)
end
function c9910331.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c9910331.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910331.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910331.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910331.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910331.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x956,5,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x956,5,REASON_COST)
end
function c9910331.filter3(c,e,tp)
	return c:IsSetCard(0x956) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c9910331.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910331.filter3,tp,LOCATION_DECK+LOCATION_HAND,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_HAND)
end
function c9910331.operation3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft1<=0 or ft2<=0 then return end
	if ft1>ft2 then ft1=ft2 end
	local g=Duel.GetMatchingGroup(c9910331.filter3,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local ct=math.floor(g:GetCount()/2)
	if ct==0 then return end
	if ct>ft1 then ct=ft1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910331,3))
	local sg1=g:Select(tp,1,ct,nil)
	local tc=sg1:GetFirst()
	g:Sub(sg1)
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SYNCHRO_LEVEL)
		e2:SetValue(c9910331.slevel)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=sg1:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910331,4))
	local sg2=g:Select(tp,sg1:GetCount(),sg1:GetCount(),nil)
	tc=sg2:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SYNCHRO_LEVEL)
		e2:SetValue(c9910331.slevel)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=sg2:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c9910331.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 65536+lv
end
