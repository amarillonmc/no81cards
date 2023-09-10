--异界共鸣#FE幻想异闻录
function c75070011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,75070011+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c75070011.target)
	e1:SetOperation(c75070011.activate)
	c:RegisterEffect(e1)
end 
function c75070011.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75070011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75070011.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end 
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) then 
		e:SetLabel(1) 
	else 
		e:SetLabel(0) 
	end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end 
function c75070011.espfil(c,mg) 
	return c:IsLinkSummonable(mg,nil,1,99) and c:IsSetCard(0x757) 
end 
function c75070011.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c75070011.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
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
		Duel.SpecialSummonComplete() 
		local mg=Duel.GetMatchingGroup(Card.IsCanBeLinkMaterial,tp,LOCATION_MZONE,0,nil,nil)
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeLinkMaterial,tp,LOCATION_HAND,0,nil,nil)
		if e:GetLabel()==1 then 
			mg:Merge(mg1) 
		end   
		if Duel.IsExistingMatchingCard(c75070011.espfil,tp,LOCATION_EXTRA,0,1,nil,mg) and Duel.SelectYesNo(tp,aux.Stringid(75070011,0)) then 
			local tc=Duel.SelectMatchingCard(tp,c75070011.espfil,tp,LOCATION_EXTRA,0,1,1,nil,mg):GetFirst() 
			Duel.LinkSummon(tp,tc,mg,nil,1,99)
		end 
	end
end 









