--摇曳飘荡的泡影
function c75000716.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,445595+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c75000716.target)
	e1:SetOperation(c75000716.activate)
	c:RegisterEffect(e1)
end 
function c75000716.spfil1(c,e,tp)
	return c:IsSetCard(0x750) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end 
function c75000716.ckfil(c) 
	return c:IsFaceup() and c:IsCode(75000701)  
end 
function c75000716.spfil2(c,e,tp)
	return c:IsSetCard(0x750) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c75000716.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsExistingMatchingCard(c75000716.spfil1,tp,LOCATION_DECK,0,1,nil,e,tp) 
	local b2=Duel.IsExistingMatchingCard(c75000716.ckfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c75000716.spfil2,tp,LOCATION_REMOVED,0,1,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (b1 or b2) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c75000716.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end 
	local g1=Duel.GetMatchingGroup(c75000716.spfil1,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c75000716.spfil2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if Duel.IsExistingMatchingCard(c75000716.ckfil,tp,LOCATION_MZONE,0,1,nil) then 
		g1:Merge(g2) 
	end  
	if g1:GetCount()>0 then 
		local sg=g1:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end



