local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id+4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,1000,1000,8,RACE_REPTILE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,1000,1000,8,RACE_REPTILE,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,id+1)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(s.chcon1)
		e1:SetOperation(s.chop1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetCondition(s.chcon2)
		e2:SetOperation(s.chop2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function s.chcon1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ty=re:GetActiveType()
	return ty&TYPE_MONSTER~=0 or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.chop1(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function s.chcon2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetFlagEffect(id)>0
end
function s.chop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop(re))
end
function s.repop(te)
    return  function(e,tp,eg,ep,ev,re,r,rp)
	    local p1=Duel.GetTurnPlayer()
    	local p2=1-p1
    	s.do_ritual(p1,e,te)
	    s.do_ritual(p2,e,te)
    end
end
function s.ritual_filter(c,e,tp)
	return c:IsCode(id+4) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function s.lv_func(c)
	return 8
end
function s.tdfilter(c,is_mon,is_spell,is_trap)
	return (is_mon and c:IsType(TYPE_MONSTER))
		or (is_spell and c:IsType(TYPE_SPELL))
		or (is_trap and c:IsType(TYPE_TRAP))
end
function s.do_ritual(p,e,re)
	local mg=Duel.GetRitualMaterial(p):Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if not Duel.IsExistingMatchingCard(Auxiliary.RitualUltimateFilter,p,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,s.ritual_filter,e,p,mg,nil,s.lv_func,"Greater") then return end
	if not Duel.SelectYesNo(p,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(p,aux.NecroValleyFilter(Auxiliary.RitualUltimateFilter),p,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,s.ritual_filter,e,p,mg,nil,s.lv_func,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_RELEASE)
		Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(tc,8,"Greater")
		local mat=mg:SelectSubGroup(p,Auxiliary.RitualCheck,true,1,8,p,tc,8,"Greater")
		Auxiliary.GCheckAdditional=nil
		if not mat then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,p,p,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		if tc:IsSummonLocation(LOCATION_DECK) then
			local rc=re:GetHandler()
			local is_mon=rc:IsType(TYPE_MONSTER)
			local is_spell=rc:IsType(TYPE_SPELL)
			local is_trap=rc:IsType(TYPE_TRAP)
			local g=Duel.GetMatchingGroup(s.tdfilter,1-p,LOCATION_DECK,0,nil,is_mon,is_spell,is_trap)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,1-p,aux.Stringid(id,1))
				local sg=g:Select(1-p,1,1,nil)
				local tdc=sg:GetFirst()
				if tdc then
					Duel.ShuffleDeck(1-p)
					Duel.MoveSequence(tdc,SEQ_DECKTOP)
					Duel.ConfirmDecktop(1-p,1)
				end
			end
		end
	end
end