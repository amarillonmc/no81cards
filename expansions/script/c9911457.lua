--闪蝶幻乐手 八潮瑠唯
function c9911457.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9911457)
	e1:SetTarget(c9911457.settg)
	e1:SetOperation(c9911457.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	e3:SetCondition(c9911457.setcon)
	c:RegisterEffect(e3)
	c9911457.morfonica_summon_effect=e1
	--adjust(disablecheck)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(0xff)
	e4:SetLabelObject(e1)
	e4:SetOperation(c9911457.adjustop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetLabelObject(e2)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetLabelObject(e3)
	c:RegisterEffect(e6)
	--to hand(self)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCountLimit(1,9911458)
	e7:SetCondition(c9911457.thcon2)
	e7:SetTarget(c9911457.thtg2)
	e7:SetOperation(c9911457.thop2)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e8)
end
function c9911457.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if Duel.GetFlagEffect(tp,9911469)~=0 then
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e1:SetProperty(EFFECT_FLAG_DELAY)
	end
end
function c9911457.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911470)~=0
end
function c9911457.pfilter1(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x3952) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c9911457.pfilter2(c)
	return c:IsLocation(LOCATION_MZONE) and (c:IsCanTurnSet() or not c:IsPosition(POS_FACEUP_ATTACK))
end
function c9911457.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9911457.pfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c9911457.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c9911457.pfilter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local g=tc:GetColumnGroup()
		if #g>0 and g:IsExists(c9911457.pfilter2,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9911457,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sc=g:FilterSelect(tp,c9911457.pfilter2,1,1,nil):GetFirst()
			if sc:IsPosition(POS_FACEUP_ATTACK) then
				Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE)
			elseif sc:IsPosition(POS_FACEDOWN_DEFENSE) then
				Duel.ChangePosition(sc,POS_FACEUP_ATTACK)
			elseif sc:IsCanTurnSet() then
				local pos=Duel.SelectPosition(tp,sc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
				Duel.ChangePosition(sc,pos)
			else
				Duel.ChangePosition(sc,POS_FACEUP_ATTACK)
			end
		end
	end
end
function c9911457.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c9911457.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c9911457.sumfilter(c)
	return c:IsSetCard(0x3952) and c:IsSummonable(true,nil)
end
function c9911457.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND)
		and Duel.IsExistingMatchingCard(c9911457.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9911457,1)) then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,c9911457.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
