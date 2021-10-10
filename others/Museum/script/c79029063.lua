--龙门·部署-近卫局の集结
function c79029063.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
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
	e2:SetCost(c79029063.lvcost)
	e2:SetTarget(c79029063.lvtg)
	e2:SetOperation(c79029063.lvop)
	c:RegisterEffect(e2)   
end
function c79029063.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,2,nil,0x1905)
end
function c79029063.hfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x1905)
end
function c79029063.tgfilter(c,e,tp)
	return c:IsSetCard(0x1905) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA)) or (Duel.GetLocationCount(tp,LOCATION_MZONE) and c:IsLocation(LOCATION_DECK))) and Duel.IsExistingMatchingCard(c79029063.hfilter,tp,LOCATION_DECK,0,1,c)
end
function c79029063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029063.tgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029063.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029063.tgfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then 
	Duel.BreakEffect()
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local dg=Duel.SelectMatchingCard(tp,c79029063.hfilter,tp,LOCATION_DECK,0,1,1,tc)
	if dg:GetCount()>0 then 
		Duel.SendtoHand(dg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,dg) 
	end
	end
end
function c79029063.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c79029063.filter2(c)
	return c:IsSetCard(0x1905) and c:IsReleasable()
end
function c79029063.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029063.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c79029063.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029063.filter2,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.Release(tc,REASON_COST)
	local atk=tc:GetBaseAttack()
	Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end   

