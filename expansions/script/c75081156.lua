--圆环魔女召唤
function c75081156.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75081156+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75081156.target)
	e1:SetOperation(c75081156.activate)
	c:RegisterEffect(e1) 
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75081156,1))
	--e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,75081157)
	e2:SetCondition(c75081156.thcon)
	e2:SetTarget(c75081156.thtg)
	e2:SetOperation(c75081156.thop)
	c:RegisterEffect(e2)  
	--Send to extra
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75081156,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,75081158)
	e4:SetCondition(c75081156.tecon)
	e4:SetTarget(c75081156.tetg)
	e4:SetOperation(c75081156.teop)
	c:RegisterEffect(e4)	
end
function c75081156.selfilter(c,e,tp,check)
	return c:IsSetCard(0x6754) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP))
end
function c75081156.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,c)
	if chk==0 then return Duel.IsExistingMatchingCard(c75081156.selfilter,tp,LOCATION_DECK,0,1,nil,e,tp,check) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c75081156.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c75081156.selfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check)
	if #g==0 then return end
	local tc=g:GetFirst()
	if check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	if tc:IsLocation(LOCATION_HAND+LOCATION_MZONE) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c)
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			Duel.Destroy(g1,REASON_EFFECT)
		end
	end
end
--
--
function c75081156.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_HAND)
end
function c75081156.thfilter(c)
	return c:IsSetCard(0x6754) and c:IsAbleToHand()
end
function c75081156.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c75081156.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
--
function c75081156.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x6754)
end
function c75081156.tecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c75081156.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c75081156.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end