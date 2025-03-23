--恋慕屋敷的泯妖精
function c9911080.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9911080)
	e1:SetCondition(c9911080.ctcon)
	e1:SetTarget(c9911080.cttg)
	e1:SetOperation(c9911080.ctop)
	c:RegisterEffect(e1)
	--to hand or grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,9911055)
	e2:SetCondition(c9911080.thcon)
	e2:SetTarget(c9911080.thtg)
	e2:SetOperation(c9911080.thop)
	c:RegisterEffect(e2)
end
function c9911080.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9911080.addfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c9911080.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911080.addfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0x1954)
end
function c9911080.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9911080.addfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		local tc
		if tg:GetCount()>1 then
			if tg:IsExists(Card.IsCanAddCounter,1,nil,0x1954,4) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
				local sg=tg:FilterSelect(tp,Card.IsCanAddCounter,1,1,nil,0x1954,4)
				Duel.HintSelection(sg)
				tc=sg:GetFirst()
			end
		elseif tg:GetFirst():IsCanAddCounter(0x1954,4) then
			Duel.HintSelection(tg)
			tc=tg:GetFirst()
		end
		if tc then tc:AddCounter(0x1954,4) end
	end
end
function c9911080.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9911080.thfilter(c)
	return c:IsSetCard(0x9954) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9911080.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1954,4,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c9911080.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9911080.filter(c,tp)
	return c:GetCounter(0x1954)>0 and c:IsCanRemoveCounter(tp,0x1954,1,REASON_EFFECT)
end
function c9911080.gcfilter(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsControlerCanBeChanged()
end
function c9911080.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	if not Duel.IsCanRemoveCounter(tp,1,1,0x1954,4,REASON_EFFECT) then return end
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911080,i))
		local sc=Duel.SelectMatchingCard(tp,c9911080.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp):GetFirst()
		sc:RemoveCounter(tp,0x1954,1,REASON_EFFECT)
		if sc:IsLocation(LOCATION_MZONE) then sg:AddCard(sc) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9911080.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	local res=false
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
			res=true
		end
	else
		if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
			res=true
		end
	end
	if res and sg:IsExists(c9911080.gcfilter,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(9911080,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local cg=sg:FilterSelect(tp,c9911080.gcfilter,1,1,nil,tp)
		if cg:GetCount()>0 then
			Duel.HintSelection(cg)
			Duel.GetControl(cg:GetFirst(),tp)
		end
	end
end
