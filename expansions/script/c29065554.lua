--方舟骑士异格 
c29065554.named_with_Arknight=1
function c29065554.initial_effect(c)
	--SpecialSummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c29065554.cost)
	e1:SetTarget(c29065554.target) 
	e1:SetOperation(c29065554.activate) 
	c:RegisterEffect(e1) 
end 
function c29065554.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c29065554.filter1(c,e,tp) 
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c29065554.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,c:GetCode())
end 
function c29065554.filter2(c,e,tp,tcode)  
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_RITUAL) and c.assault_name==tcode and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false,POS_FACEUP)   
end
function c29065554.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c29065554.filter1,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp)
	end
	local rg=Duel.SelectMatchingCard(tp,c29065554.filter1,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.SendtoGrave(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND)
end
function c29065554.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c29065554.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end





 