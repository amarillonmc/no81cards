--异种 番兵
function c16104610.initial_effect(c)
	--be target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16104610,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,16104610)
	e1:SetCondition(c16104610.condition)
	e1:SetCost(c16104610.cost)
	e1:SetTarget(c16104610.target)
	e1:SetOperation(c16104610.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16104610,1))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98500193)
	e2:SetTarget(c16104610.hsptg)
	e2:SetOperation(c16104610.hspop)
	c:RegisterEffect(e2)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16104610,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98500193)
	e3:SetTarget(c16104610.destg)
	e3:SetOperation(c16104610.desop)
	c:RegisterEffect(e3)
end
function c16104610.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown() and not re:IsActiveType(TYPE_MONSTER)
end
function c16104610.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local op=Duel.SelectOption(tp,aux.Stringid(16104610,9),aux.Stringid(16104610,10))
	if op==0 then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
	else
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function c16104610.filter(c)
	return c:IsFacedown() or c:IsFaceup() and  c:IsControlerCanBeChanged()
end
function c16104610.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c16104610.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c16104610.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c16104610.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c16104610.filter,tp,0,LOCATION_MZONE,1,nil)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c16104610.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
		if Duel.GetControl(tc,tp,PHASE_MAIN1,2)~=0 and Duel.IsExistingMatchingCard(c16104610.filter3,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(16104610,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,c16104610.filter3,tp,LOCATION_MZONE,0,1,1,nil)
			local tc=g:GetFirst()
			if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
				Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			
		end
	end
end
function c16104610.filter3(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c16104610.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return chkc:IsLocation(LOCATION_MZONE) and c16104610.filter3(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (e:GetHandler():IsSummonable(true,nil) or e:GetHandler():IsMSetable(true,nil)) and (Duel.IsExistingTarget(c16104610.filter3,tp,LOCATION_MZONE,0,1,nil) or (Duel.IsPlayerAffectedByEffect(tp,98500000) and Duel.IsExistingTarget(c16104610.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if Duel.IsPlayerAffectedByEffect(tp,98500000) then
		local g=Duel.SelectTarget(tp,c16104610.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	else
		local g=Duel.SelectTarget(tp,c16104610.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c16104610.filter4(c)
	return c:IsFacedown()
end
function c16104610.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return false end
	local ts={}
	local index=1
	if e:GetHandler():IsSummonable(true,nil) then
		ts[index]=aux.Stringid(16104610,7)
		index=index+1
	end
	if e:GetHandler():IsMSetable(true,nil) then
	   ts[index]=aux.Stringid(16104610,8)
	   index=index+1
	end
	local c=e:GetHandler()
	local opt=Duel.SelectOption(tp,table.unpack(ts))
	if ts[opt+1]==aux.Stringid(16104610,7) then
		Duel.Summon(tp,c,true,nil)
	elseif ts[opt+1]==aux.Stringid(16104610,8) then
		Duel.MSet(tp,c,true,nil)
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
			Duel.BreakEffect()
			local g2=Duel.GetMatchingGroup(c16104610.filter4,tp,LOCATION_MZONE,0,nil)
				Duel.ShuffleSetCard(g2)
		end
	end
end
function c16104610.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c16104610.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.Destroy(sg,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			if Duel.IsExistingTarget(c16104610.filter4,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(16104610,4)) then
				local g2=Duel.SelectMatchingCard(tp,c16104610.filter,tp,0,LOCATION_MZONE,1,1,nil)
				local tc2=g2:GetFirst()	   
					Duel.GetControl(tc2,tp,PHASE_END,1)
				
			end
		end
	end
end
