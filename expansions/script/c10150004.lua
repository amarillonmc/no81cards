--黑白的冲击
function c10150004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10150004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10150004.target)
	e1:SetOperation(c10150004.activate)
	c:RegisterEffect(e1)		
end

function c10150004.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_DARK)
end

function c10150004.filter3(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_LIGHT)
end

function c10150004.filter0(c,e,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(c10150004.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) 
end

function c10150004.filter1(c,e,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and Duel.IsExistingMatchingCard(c10150004.filter3,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) 
end

function c10150004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(c10150004.filter0,tp,0,LOCATION_MZONE,1,nil,e,tp) or Duel.IsExistingMatchingCard(c10150004.filter1,tp,0,LOCATION_MZONE,1,nil,e,tp)) end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10150004,2))
	if Duel.IsExistingMatchingCard(c10150004.filter0,tp,0,LOCATION_MZONE,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c10150004.filter1,tp,0,LOCATION_MZONE,1,nil,e,tp) then
		op=Duel.SelectOption(tp,aux.Stringid(10150004,0),aux.Stringid(10150004,1))
	elseif Duel.IsExistingMatchingCard(c10150004.filter1,tp,0,LOCATION_MZONE,1,nil,e,tp) then
		Duel.SelectOption(tp,aux.Stringid(10150004,1))
		op=1
	else
		Duel.SelectOption(tp,aux.Stringid(10150004,0))
		op=0
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c10150004.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local op=e:GetLabel()
	local tc=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if op==0 then
	   tc=Duel.SelectMatchingCard(tp,c10150004.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	else
	   tc=Duel.SelectMatchingCard(tp,c10150004.filter3,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	end
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_DISABLE)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e1)
	   local e2=e1:Clone()
	   e2:SetCode(EFFECT_DISABLE_EFFECT)
	   tc:RegisterEffect(e2)
	end
end
