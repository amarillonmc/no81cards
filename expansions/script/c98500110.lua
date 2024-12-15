--异种 白
function c98500110.initial_effect(c)
	--be target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98500110,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98500110)
	e1:SetCondition(c98500110.condition)
	e1:SetCost(c98500110.cost)
	e1:SetTarget(c98500110.target)
	e1:SetOperation(c98500110.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500110,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98500111)
	e2:SetTarget(c98500110.hsptg)
	e2:SetOperation(c98500110.hspop)
	c:RegisterEffect(e2)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500110,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98500111)
	e3:SetTarget(c98500110.destg)
	e3:SetOperation(c98500110.desop)
	c:RegisterEffect(e3)
end
function c98500110.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown() and re:IsActiveType(TYPE_MONSTER)
end
function c98500110.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local op=Duel.SelectOption(tp,aux.Stringid(98500110,9),aux.Stringid(98500110,10))
	if op==0 then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
	else
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function c98500110.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c98500110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c98500110.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(98500110,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c98500110.filter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
	end
end
function c98500110.filter3(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c98500110.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98500110.filter3(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
		and (Duel.IsExistingTarget(c98500110.filter3,tp,LOCATION_MZONE,0,1,nil) or (Duel.IsPlayerAffectedByEffect(tp,16104622) and Duel.IsExistingTarget(c98500110.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if Duel.IsPlayerAffectedByEffect(tp,16104622) then
		local g=Duel.SelectTarget(tp,c98500110.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	else
		local g=Duel.SelectTarget(tp,c98500110.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c98500110.filter4(c)
	return c:IsFacedown()
end
function c98500110.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
				Duel.BreakEffect()
				local g2=Duel.GetMatchingGroup(c98500110.filter4,tp,LOCATION_MZONE,0,nil)
				Duel.ShuffleSetCard(g2)
			end
		end
	end
end
function c98500110.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c98500110.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.Destroy(sg,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			if Duel.IsExistingTarget(c98500110.filter4,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98500110,4)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
