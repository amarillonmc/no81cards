--青眼混沌极灵龙
function c75038001.initial_effect(c)
	aux.AddCodeList(c,21082832)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,75038001)
	e1:SetCondition(c75038001.hspcon)
	e1:SetTarget(c75038001.hsptg)
	e1:SetOperation(c75038001.hspop)
	c:RegisterEffect(e1)
	--special summon grave 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,75038002) 
	e2:SetTarget(c75038001.sptg)
	e2:SetOperation(c75038001.spop)
	c:RegisterEffect(e2)
	if not c75038001.global_check then
		c75038001.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c75038001.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c75038001.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if tc:IsAttribute(ATTRIBUTE_DARK) and tc:IsSetCard(0xcf) and tc:IsType(TYPE_RITUAL) then 
			Duel.RegisterFlagEffect(tc:GetControler(),75038001,RESET_PHASE+PHASE_END,0,1) 
		end 
		tc=eg:GetNext()
	end
end 
function c75038001.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFlagEffect(tp,75038001)>0 or Duel.GetFlagEffect(1-tp,75038001)>0) and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c75038001.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75038001.sthfil(c)
	return c:IsCode(22804410) and c:IsAbleToHand() 
end 
function c75038001.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then 
		c:CompleteProcedure()
		if Duel.IsExistingMatchingCard(c75038001.sthfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75038001,0)) then 
			Duel.BreakEffect()
			local sg=Duel.SelectMatchingCard(tp,c75038001.sthfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		end 
	end
end
function c75038001.spfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(8)
end
function c75038001.spsumfilter1(c,e,tp) 
	if c:IsType(TYPE_RITUAL) then 
		return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP,tp)
	else 
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp) 
	end 
end
function c75038001.spsumfilter2(c,e,tp)
	if c:IsType(TYPE_RITUAL) then 
		return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP,1-tp)
	else 
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) 
	end 
end
function c75038001.gcheck(g,e,tp)
	if #g~=2 then return false end
	local ac=g:GetFirst()
	local bc=g:GetNext()
	return (c75038001.spsumfilter1(ac,e,tp) and c75038001.spsumfilter2(bc,e,tp)
		or c75038001.spsumfilter1(bc,e,tp) and c75038001.spsumfilter2(ac,e,tp))
	   and g:IsExists(Card.IsSetCard,1,nil,0xdd)
end
function c75038001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c75038001.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if chk==0 then
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft1>0 and ft2>0
			and g:CheckSubGroup(c75038001.gcheck,2,2,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c75038001.gcheck,false,2,2,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,LOCATION_GRAVE)
end
function c75038001.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or ft1<=0 or ft2<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if not g:CheckSubGroup(c75038001.gcheck,2,2,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75038001,1))
	local sg=g:FilterSelect(tp,c75038001.spsumfilter1,1,1,nil,e,tp) 
	local tc1=sg:GetFirst() 
	local tc2=(g-sg):GetFirst() 
	if tc1:IsType(TYPE_RITUAL) then 
		Duel.SpecialSummonStep(tc1,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) 
		tc1:CompleteProcedure()
	else 
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
	end 
	if tc2:IsType(TYPE_RITUAL) then 
		Duel.SpecialSummonStep(tc2,SUMMON_TYPE_RITUAL,tp,1-tp,false,true,POS_FACEUP) 
		tc2:CompleteProcedure()
	else 
		Duel.SpecialSummonStep(tc2,0,tp,1-tp,false,false,POS_FACEUP)
	end 
	Duel.SpecialSummonComplete()
end




