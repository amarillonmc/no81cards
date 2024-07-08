--梦之王国 皮瑟斯
function c75075610.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75075610+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c75075610.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75075610,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c75075610.destg)
	e2:SetOperation(c75075610.desop)
	c:RegisterEffect(e2)	
end
function c75075610.thfilter(c,e,tp)
	if not (c:IsSetCard(0x75a) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function c75075610.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c75075610.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(75075610,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c75075610.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local tc=g:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end
--
function c75075610.cfilter1(c,e,tp)
	return c:IsSetCard(0x75a) and c:IsType(TYPE_MONSTER) 
		and Duel.IsExistingMatchingCard(c75075610.cfilter2,tp,LOCATION_MZONE,0,1,c,e,tp,c) and Duel.GetMZoneCount(tp,c)>0
end
function c75075610.cfilter2(c,e,tp,tc)
	if c:IsCode(tc:GetCode()) or c:GetOriginalAttribute()~=tc:GetOriginalAttribute() then return false end
	local sg=Group.FromCards(tc,c)
	local g=Duel.GetMatchingGroup(c75075610.spfilter,tp,LOCATION_EXTRA,0,sg,e,tp)
	return c:IsSetCard(0x75a) and c:IsType(TYPE_MONSTER) and g:GetClassCount(Card.GetCode)>1
end
function c75075610.spfilter(c,tc,e,tp)
	return c:GetOriginalAttribute()==tc:GetOriginalAttribute()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x75a)
end
function c75075610.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c75075610.cfilter1,tp,LOCATION_MZONE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c75075610.cfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c75075610.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c75075610.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		if Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75075610.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end