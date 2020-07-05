--龙门·部署-近卫局の集结
function c79029063.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029063+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c79029063.condition)
	e1:SetTarget(c79029063.target)
	e1:SetOperation(c79029063.activate)
	c:RegisterEffect(e1) 
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c79029063.lvcost)
	e2:SetTarget(c79029063.lvtg)
	e2:SetOperation(c79029063.lvop)
	c:RegisterEffect(e2)   
end
function c79029063.filter(c)
	return c:IsSetCard(0x1905) and c:IsType(TYPE_MONSTER)
end
function c79029063.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79029063.filter,tp,LOCATION_MZONE,0,2,nil)
end
function c79029063.tgfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x1905)
end
function c79029063.hfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x1905)
end
function c79029063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029063.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
	function c79029063.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029063.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if Duel.IsExistingMatchingCard(c79029063.hfilter,tp,LOCATION_DECK,0,1,nil)
	then local a=Duel.SelectMatchingCard(tp,c79029063.hfilter,tp,LOCATION_DECK,0,1,1,nil)
	if a:GetCount()>0 then 
		Duel.SendtoHand(a,tp,REASON_EFFECT)  
end
end
end
end
function c79029063.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c79029063.filter2(c)
	return c:IsSetCard(0xa900) and c:IsFaceup() and c:GetLevel()>0
end
function c79029063.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029063.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029063.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c79029063.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c79029063.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetBaseAttack()
	Duel.Release(tc,REASON_COST)
	Duel.Damage(1-tp,atk,REASON_EFFECT)
end   

