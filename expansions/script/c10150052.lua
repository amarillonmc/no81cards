--终焉的神战
function c10150052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10150052+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10150052.cost)
	e1:SetTarget(c10150052.target)
	e1:SetOperation(c10150052.activate)
	c:RegisterEffect(e1)	   
end
function c10150052.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLP(tp)>100 end
	Duel.PayLPCost(tp,Duel.GetLP(tp)-100)
end
function c10150052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10150052.filter,tp,0x13,0,1,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0x13)
end
function c10150052.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10150052.filter,tp,0x13,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 or g:GetCount()<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10150052,0))
	local sg=g:Select(tp,1,1,nil)
	if sg:GetCount()<=0 or not Duel.SpecialSummonStep(sg:GetFirst(),0,tp,tp,true,false,POS_FACEUP_ATTACK) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10150052,1))
	local sg2=Duel.SelectMatchingCard(tp,c10150052.filter2,tp,0x13,0,1,1,sg:GetFirst(),e,tp)
	if sg2:GetCount()<=0 or not Duel.SpecialSummonStep(sg2:GetFirst(),0,tp,1-tp,true,false,POS_FACEUP_ATTACK) then return end  
	sg:Merge(sg2)
	Duel.SpecialSummonComplete()
	for tc in aux.Next(sg) do  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(4000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c10150052.efilter)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
	end
end
function c10150052.efilter(e,re)
	return e:GetHandler()~=re:GetOwner() and re:IsActiveType(TYPE_MONSTER)
end
function c10150052.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DEVINE) and c:GetOriginalLevel()==10
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_ATTACK,tp) and Duel.IsExistingMatchingCard(c10150052.filter2,tp,0x13,0,1,c,e,tp)
end
function c10150052.filter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DEVINE) and c:GetOriginalLevel()==10
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_ATTACK,1-tp)
end
