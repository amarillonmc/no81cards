--枪管掩护
function c21194020.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21194020,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_GRAVE_ACTION+CATEGORY_ATKCHANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(2)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c21194020.tg)
	e1:SetOperation(c21194020.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21194020,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,21194020)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c21194020.tg2)
	e2:SetOperation(c21194020.op2)
	c:RegisterEffect(e2)	
end
function c21194020.q(c)
	return c:IsSetCard(0x102) and c:GetBaseAttack()>0 and c:IsFaceup()
end
function c21194020.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21194020.q,tp,4,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21194020.q,tp,4,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21194020.w(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(1) and c:IsAbleToDeck()
end
function c21194020.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
	local g=Duel.GetFieldGroup(tp,4,0)
	if #g<=0 then return end
	local x=0
	local atk=math.floor(tc:GetBaseAttack()/2)
		for cc in aux.Next(g) do
			if not cc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			e1:SetValue(atk)
			cc:RegisterEffect(e1)
			if not cc:IsHasEffect(108) then x = x + 1 end
			end
		end
		if x>0 and Duel.IsExistingMatchingCard(c21194020.w,tp,0x10,0,2,nil) and Duel.SelectYesNo(tp,aux.Stringid(21194020,2)) then
		Duel.Hint(3,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,c21194020.w,tp,0x10,0,2,2,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)	
		end
	end
end
function c21194020.e(c)
	return c:IsSetCard(0x102) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c21194020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c21194020.e,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c21194020.e,tp,LOCATION_GRAVE,0,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
end
function c21194020.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	end
end