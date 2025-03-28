--异种 亡魂
function c98500120.initial_effect(c)
	--be target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98500120,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98500120)
	e1:SetCondition(c98500120.condition)
	e1:SetCost(c98500120.cost)
	e1:SetTarget(c98500120.target)
	e1:SetOperation(c98500120.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500120,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98500121)
	e2:SetTarget(c98500120.hsptg)
	e2:SetOperation(c98500120.hspop)
	c:RegisterEffect(e2)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500120,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98500121)
	e3:SetTarget(c98500120.destg)
	e3:SetOperation(c98500120.desop)
	c:RegisterEffect(e3)
end
function c98500120.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()
end
function c98500120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local op=Duel.SelectOption(tp,aux.Stringid(98500120,9),aux.Stringid(98500120,10))
	if op==0 then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
	else
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function c98500120.filter(c)
	return c:IsSetCard(0x985) and c:IsAbleToHand()
end
function c98500120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98500120.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98500120.filter2(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil) and c:IsSetCard(0x985)
end
function c98500120.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98500120.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			if Duel.IsExistingMatchingCard(c98500120.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98500120,3)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local g2=Duel.SelectMatchingCard(tp,c98500120.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
				local tc=g2:GetFirst()
				if tc:IsSummonable(true,nil) and (not tc:IsMSetable(true,nil) or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then
					Duel.Summon(tp,tc,true,nil)
				else
					Duel.MSet(tp,tc,true,nil)
				end
			end
		end
	end
end
function c98500120.filter3(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c98500120.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98500120.filter3(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and (Duel.IsExistingTarget(c98500120.filter3,tp,LOCATION_MZONE,0,1,nil) or (Duel.IsPlayerAffectedByEffect(tp,98500000) and Duel.IsExistingTarget(c98500120.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if Duel.IsPlayerAffectedByEffect(tp,98500000) then
		local g=Duel.SelectTarget(tp,c98500120.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	else
		local g=Duel.SelectTarget(tp,c98500120.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c98500120.filter4(c)
	return c:IsFacedown()
end
function c98500120.hspop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
				Duel.BreakEffect()
				local g2=Duel.GetMatchingGroup(c98500120.filter4,tp,LOCATION_MZONE,0,nil)
				Duel.ShuffleSetCard(g2)
			end
		end
	end
end
function c98500120.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsExistingMatchingCard(c98500120.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c98500120.desop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(c98500120.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(98500120,4)},
		{b2,aux.Stringid(98500120,5)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.HintSelection(g)
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
				
			end
		end
	elseif op==2 then
		local g=Duel.GetMatchingGroup(c98500120.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
		end
	end
	if Duel.IsExistingTarget(c98500120.filter4,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98500120,6)) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g:GetCount()>0 then
			Duel.ConfirmCards(tp,g)
			Duel.ShuffleHand(1-tp)
		end
	end
end
