--失控磁盘的再组装
function c95101221.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c95101221.target)
	e1:SetOperation(c95101221.activate)
	c:RegisterEffect(e1)
end
function c95101221.rlfilter(c,tp)
	return c:IsSetCard(0x6bb0) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0
end
function c95101221.posfilter(c)
	return c:IsSetCard(0x6bb0) and c:IsFaceup() and c:IsCanChangePosition()
end
function c95101221.spfilter(c,e,tp)
	return c:IsSetCard(0x6bb0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95101221.thfilter(c)
	return c:IsSetCard(0x6bb0) and c:IsAbleToHand()
end
function c95101221.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckReleaseGroupEx(tp,c95101221.rlfilter,1,REASON_COST,true,nil,tp) and Duel.IsExistingMatchingCard(c95101221.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,95101221)==0
	local b2=Duel.IsExistingTarget(c95101221.posfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,95101221+1)==0
	local b3=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c95101221.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,95101221+2)==0
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(95101221,0)},
		{b2,aux.Stringid(95101221,1)},
		{b3,aux.Stringid(95101221,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectReleaseGroupEx(tp,c95101221.rlfilter,1,1,REASON_COST,true,nil,tp)
		Duel.Release(g,REASON_COST)
		Duel.RegisterFlagEffect(tp,95101221,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		e:SetCategory(CATEGORY_POSITION)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectTarget(tp,c95101221.posfilter,tp,LOCATION_MZONE,0,1,7,nil)
		Duel.RegisterFlagEffect(tp,95101221+1,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
	elseif op==3 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
		Duel.RegisterFlagEffect(tp,95101221+2,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c95101221.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c95101221.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		local g=Duel.GetTargetsRelateToChain()
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c95101221.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
