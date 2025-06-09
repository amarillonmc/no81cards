--黑之牙的『狂犬』 莱纳斯
function c75081034.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75081034,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,75081034)
	e1:SetCondition(c75081034.thcon)
	e1:SetTarget(c75081034.thtg)
	e1:SetOperation(c75081034.thop)
	c:RegisterEffect(e1)
	--atk update
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c75081034.atkval)
	c:RegisterEffect(e2)	
end
function c75081034.atkval(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end
--
function c75081034.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75081034.cfilter1,1,nil,tp) or eg:IsExists(c75081034.cfilter2,1,nil,tp)
end
function c75081034.cfilter1(c,tp)
	return c:IsSetCard(0xa754) and c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and c:IsPreviousControler(tp) 
end
function c75081034.cfilter2(c,tp)
	return c:IsSetCard(0xa754) and c:IsLocation(LOCATION_DECK+LOCATION_REMOVED) and c:IsPreviousControler(tp) 
end
function c75081034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=eg:IsExists(c75081034.cfilter1,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=eg:IsExists(c75081034.cfilter2,1,nil,tp) and c:IsAbleToGrave() 
	if chk==0 then return b1 or b2 end
	if b1 and b2 and Duel.SelectOption(tp,1152,1190)==0 then
		e:SetLabel(1)
	else
		e:SetLabel(2)
	end
	if b1 then
		e:SetLabel(1)
	end
	if b2 then
		e:SetLabel(2)
	end
end
function c75081034.spfilter(c,e,tp)
	return c:IsSetCard(0xa754) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75081034.thfilter(c)
	return c:IsSetCard(0xa754) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
end
function c75081034.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local egg=eg:Filter(c75081034.cfilter1,nil,tp)
	local x=0
	local y=0
	local tc=egg:GetFirst()
	while tc do
		y=tc:GetBaseAttack()
		x=x+y
		tc=egg:GetNext()
	end
	local label=e:GetLabel()
	if label==1 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			Duel.Damage(tp,x,REASON_EFFECT)
		end
	end
	if label==2 then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND)  and Duel.IsExistingMatchingCard(c75081034.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(75081034,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=Duel.SelectMatchingCard(tp,c75081034.spfilter,tp,LOCATION_HAND,0,1,2,nil,e,tp)
			if #tg>0 then
				Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end