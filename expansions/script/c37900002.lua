--神隐之地
function c37900002.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_COUNTER)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_MAIN_END+TIMINGS_CHECK_MONSTER+TIMING_SSET)
	e1:SetTarget(c37900002.tg)
	e1:SetOperation(c37900002.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c37900002.tg2)
	e2:SetValue(c37900002.indct)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c37900002.tg3)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c37900002.tg4)
	e4:SetValue(1)
	c:RegisterEffect(e4)	
end
function c37900002.q(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x389)
end
function c37900002.w(c,sc)
	return c:IsAbleToHand() and c:IsSetCard(0x389)
end
function c37900002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and (c37900002.q(chkc) or c37900002.w(chkc)) end
	if chk==0 then return Duel.IsExistingTarget(c37900002.q,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) or (Duel.IsExistingTarget(c37900002.w,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and c:GetCounter(0x1389)>=2) end	
	if Duel.IsExistingTarget(c37900002.q,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and not (Duel.IsExistingTarget(c37900002.w,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and c:GetCounter(0x1389)>=2) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c37900002.q,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	e:SetCategory(CATEGORY_TODECK)
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	end	
	if not Duel.IsExistingTarget(c37900002.q,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsExistingTarget(c37900002.w,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and c:GetCounter(0x1389)>=2 then
	c:RemoveCounter(tp,0x1389,2,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c37900002.w,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	e:SetCategory(CATEGORY_TOHAND)
	e:SetLabel(1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	end
	if (c:GetCounter(0x1389)>=2 and Duel.IsExistingTarget(c37900002.w,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)) and Duel.IsExistingTarget(c37900002.q,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(37900002,0)) then
		c:RemoveCounter(tp,0x1389,2,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c37900002.w,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		e:SetCategory(CATEGORY_TOHAND)
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c37900002.q,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		e:SetCategory(CATEGORY_TODECK)
		e:SetLabel(0)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
		end	
	end
end
function c37900002.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if e:GetLabel()==0 then
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
		c:AddCounter(0x1389,1)
		end
		else
		if Duel.SendtoHand(tc,tp,REASON_EFFECT)>0 then
		c:AddCounter(0x1389,1)
		end
		end		
	end
end
function c37900002.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c37900002.tg2(e,c)
	return c:IsType(TYPE_SPELL) and c:IsFaceup() and c:IsSetCard(0x389)
end
function c37900002.tg3(e,c)
	return c:GetAttack()<c:GetBaseAttack()
end
function c37900002.tg4(e,c)
	return c:GetDefense()>c:GetBaseDefense()
end