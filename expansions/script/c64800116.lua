--深层幻夜 郁愤
function c64800116.initial_effect(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64800116,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,64800116)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c64800116.target)
	e1:SetOperation(c64800116.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64800116,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,64810116)
	e2:SetCondition(c64800116.spcon)
	e2:SetTarget(c64800116.sptg)
	e2:SetOperation(c64800116.spop)
	c:RegisterEffect(e2)
end

--e1
function c64800116.tgfilter(c)
	return c:IsSetCard(0x341a) and c:IsAbleToGrave()
end
function c64800116.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64800116.tgfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c64800116.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,nil,tp,LOCATION_DECK+LOCATION_HAND)
end
function c64800116.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(c64800116.tgfilter,tp,LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g1=Duel.SelectMatchingCard(tp,c64800116.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	end
	if Duel.IsExistingMatchingCard(c64800116.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g2=Duel.SelectMatchingCard(tp,c64800116.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	end
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
end

--e2
function c64800116.spcfilter(c,tp)
	return c:GetControler()==tp and c:IsSetCard(0x341a) 
end
function c64800116.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c64800116.spcfilter,1,e:GetHandler(),tp)
end
function c64800116.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP))
		or Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	if not Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,e:GetHandler():GetLocation())
	end
end
function c64800116.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) then 
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	else
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(TYPE_TUNER)
			c:RegisterEffect(e1)
		end
	end
end