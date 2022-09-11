--术结天缘 米科尤
function c67200404.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableCounterPermit(0x671,LOCATION_PZONE+LOCATION_MZONE)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200404,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,67200404)
	e1:SetTarget(c67200404.sptg)
	e1:SetOperation(c67200404.spop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c67200404.ctcon)
	--e2:SetTarget(c67200404.cttg)
	e2:SetOperation(c67200404.ctop)
	c:RegisterEffect(e2)  
	--pendulum scale up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(c67200404.scaledown)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e4)	
end
function c67200404.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x5671)
end
function c67200404.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200404.ctfilter,1,nil,tp)
end
function c67200404.actfilter(c)
	return c:IsSetCard(0x5671) and c:IsAbleToHand()
end

function c67200404.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetHandler():AddCounter(0x671,2)
	if Duel.IsExistingMatchingCard(c67200404.actfilter,tp,LOCATION_EXTRA,0,1,nil) and c:GetCounter(0x671)>5 and c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(67200404,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c67200404.actfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
--
function c67200404.scaledown(e,c)
	local count=c:GetCounter(0x671)
	local a=0
	if count>6 then
		a=6
	else
		a=count
	end
	return -a
end
--

function c67200404.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function c67200404.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler()):GetFirst()
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
			if tc:IsSetCard(0x5671) and Duel.SelectYesNo(tp,aux.Stringid(67200404,1)) then
				local lv=tc:GetOriginalLevel() 
				e:GetHandler():AddCounter(0x671,lv)
			end
		end
	end
end
