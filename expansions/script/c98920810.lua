--怒怒怒征服者
function c98920810.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920810,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920810)
	e1:SetCondition(c98920810.spcon)
	e1:SetTarget(c98920810.sptg)
	e1:SetOperation(c98920810.spop)
	c:RegisterEffect(e1)	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920810,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,18514526)
	e2:SetCost(c98920810.spcost)
	e2:SetTarget(c98920810.sptg1)
	e2:SetOperation(c98920810.spop1)
	c:RegisterEffect(e2)
end
function c98920810.filter(c,e,tp)
	return c:IsSetCard(0x13a) or c:IsCode(8512558) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920810.costfilter(c)
	return bit.band(c:GetType(),0x82)==0x82 and not c:IsPublic()
end
function c98920810.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c98920810.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c98920810.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c98920810.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920810.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		g:AddCard(e:GetHandler())
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920810.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c98920810.spfilter(c,e,tp)
	return c:IsSetCard(0x82) and c:IsCanBeEffectTarget(e) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4)) or (c:IsLevelAbove(5) and c:IsAbleToHand())
end
function c98920810.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920810.spfilter(chkc,e,tp) end
	local g=Duel.GetMatchingGroup(c98920810.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local xg=g:Filter(Card.IsLevelAbove,nil,5)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0 or #xg>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local t=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=g:SelectSubGroup(tp,c98920810.kcheck,false,1,99,t)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,3,0,0)
end
function c98920810.kcheck(sg,t)
	return sg:FilterCount(Card.IsLevelBelow,nil,4)<=t
end
function c98920810.spop1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		if tc:IsLevelBelow(4) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif tc:IsLevelAbove(5) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98920810.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98920810.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end