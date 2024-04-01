--真神 神力释放
local m=91020008
local cm=c91020008
function c91020008.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local  e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(cm.tag2)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetValue(cm.val)
	c:RegisterEffect(e5)
end
function cm.fit1(c)
	return c:IsCode(91020010) or c:IsCode(91020011) or c:IsCode(91020014) and c:IsReleasable()
end
function cm.fit2(c)
	return (c:IsCode(91020011) and Duel.IsExistingMatchingCard(aux.FilterBoolFunction(Card.IsCode,10000000),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)) or (c:IsCode(91020014) and Duel.IsExistingMatchingCard(aux.FilterBoolFunction(Card.IsCode,10000010),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)) or (c:IsCode(91020010) and Duel.IsExistingMatchingCard(aux.FilterBoolFunction(Card.IsCode,10000020),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)) and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fit2,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cm.fit2,tp,LOCATION_MZONE,0,1,1,nil)
	local code=g:GetFirst():GetCode()
	e:SetLabel(code)
	Duel.Release(g,REASON_COST)
end
function cm.fit(c,e,tp)
	return c:IsCode(10000000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.fit11(c,e,tp)
	return c:IsCode(10000010) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.fit21(c,e,tp)
	return c:IsCode(10000020) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.fit0(c)
	return  not c:IsCode(91020008) and aux.IsCodeListed(c,10000000) and c:IsAbleToHand()
end
function cm.fit12(c)
	return  not c:IsCode(91020008) and aux.IsCodeListed(c,10000010) and c:IsAbleToHand()
end
function cm.fit22(c)
	return  not c:IsCode(91020008) and aux.IsCodeListed(c,10000020) and c:IsAbleToHand()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if e:GetLabel(code)==91020011  then 
	local g=Duel.SelectMatchingCard(tp,cm.fit,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)		  
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		local g1=Duel.SelectMatchingCard(tp,cm.fit0,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		end
	end
	if e:GetLabel(code)==91020014  then 
	local g=Duel.SelectMatchingCard(tp,cm.fit11,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)  
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		local g1=Duel.SelectMatchingCard(tp,cm.fit12,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		end
	end
	 if e:GetLabel(code)==91020010  then 
	local g=Duel.SelectMatchingCard(tp,cm.fit21,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		local g1=Duel.SelectMatchingCard(tp,cm.fit22,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		end
	end
	
end
--e2
function cm.tag2(e,c)
return c:IsAttribute(ATTRIBUTE_DIVINE)
end
function cm.val(e,te)
return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(TYPE_MONSTER) and (te:GetHandler():IsLevelBelow(10) or te:GetHandler():IsRankBelow(10)) 
end