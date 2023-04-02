--闪刀启动 着装
function c11513056.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCondition(c11513056.condition)
	e1:SetTarget(c11513056.target)
	e1:SetOperation(c11513056.activate)
	c:RegisterEffect(e1)
end
function c11513056.cfilter(c)
	return c:GetSequence()<5
end
function c11513056.thfilter(c,e,tp,spchk)
	return c:IsSetCard(0x1115) and (c:IsAbleToHand() or (spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c11513056.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c11513056.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11513056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 
	if chk==0 then return Duel.IsExistingMatchingCard(c11513056.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,spchk) end 
end
function c11513056.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 
	local tc=Duel.SelectMatchingCard(tp,c11513056.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,spchk):GetFirst() 
	if tc then  
		if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectOption(tp,1190,1152)==1 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c11513056.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end 
function c11513056.splimit(e,c)
	return not c:IsSetCard(0x1115) and c:IsLocation(LOCATION_EXTRA)
end

