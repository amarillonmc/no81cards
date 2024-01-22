--闪蝶幻乐手 八潮瑠唯
function c9911457.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
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
	--to hand(self)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,9911458)
	e3:SetCondition(c9911457.thcon2)
	e3:SetTarget(c9911457.thtg2)
	e3:SetOperation(c9911457.thop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
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
