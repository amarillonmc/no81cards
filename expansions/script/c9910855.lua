--千恋觅星
function c9910855.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910855.target)
	e1:SetOperation(c9910855.activate)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_BATTLE_START)
	e2:SetCondition(c9910855.sumcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910855.sumtg)
	e2:SetOperation(c9910855.sumop)
	c:RegisterEffect(e2)
end
function c9910855.cfilter1(c)
	return c:IsSetCard(0xa951) and c:IsType(TYPE_MONSTER)
		and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and c:IsAbleToGrave()
end
function c9910855.cfilter2(c)
	return c:IsSetCard(0xa951) and c:IsSummonable(true,nil) and not c:IsPublic()
end
function c9910855.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsAbleToRemove() end
	local b1=Duel.IsExistingMatchingCard(c9910855.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsExistingMatchingCard(c9910855.cfilter2,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.GetTurnPlayer()==tp then
			op=Duel.SelectOption(tp,aux.Stringid(9910855,0),aux.Stringid(9910855,1),aux.Stringid(9910855,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(9910855,0),aux.Stringid(9910855,1))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9910855,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9910855,1))+1
	end
	e:SetLabel(op)
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g1=Duel.SelectMatchingCard(tp,c9910855.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)
		Duel.SetTargetCard(g1)
		g1:GetFirst():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910855,3))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,2,nil)
		Duel.HintSelection(g2)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,g2:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		if op==1 then
			e:SetCategory(CATEGORY_REMOVE+CATEGORY_SUMMON)
		else
			e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		end
	else
		e:SetProperty(0)
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
end
function c9910855.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9910855.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
	if op~=0 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		local rg=g:Filter(Card.IsOnField,nil)
		local tc=g:Filter(Card.IsLocation,nil,LOCATION_HAND):GetFirst()
		if rg:GetCount()>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 and tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end
	if op==2 and Duel.GetTurnPlayer()==tp then
		Duel.BreakEffect()
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end
function c9910855.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c9910855.sumfilter(c)
	return c:IsSetCard(0xa951) and c:IsSummonable(true,nil)
end
function c9910855.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910855.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9910855.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910855.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
