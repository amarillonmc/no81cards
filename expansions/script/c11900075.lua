--七海的制裁
function c11900075.initial_effect(c) 
	aux.AddCodeList(c,11900074) 
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c11900075.actg) 
	e1:SetOperation(c11900075.acop) 
	c:RegisterEffect(e1) 
end
function c11900075.spfil(c,e,tp)  
   return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:IsCode(11900074)   
end 
function c11900075.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,12,e:GetHandler()) and Duel.IsExistingMatchingCard(c11900075.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,12,PLAYER_ALL,LOCATION_ONFIELD) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) 
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
    end
end 
function c11900075.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	if g:GetCount()>=12 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=Duel.SelectMatchingCard(tp,c11900075.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,12,12,nil) 
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c11900075.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) then
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(10000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			tc:RegisterEffect(e2)
			tc:CompleteProcedure()  
		end 
	end 
end