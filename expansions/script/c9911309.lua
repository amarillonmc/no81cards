--胧之渺翳 许癸厄亚魔
function c9911309.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(c9911309.efcon)
	e2:SetValue(c9911309.indct)
	c:RegisterEffect(e2)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c9911309.setcon)
	e1:SetCost(c9911309.setcost)
	e1:SetTarget(c9911309.settg)
	e1:SetOperation(c9911309.setop)
	c:RegisterEffect(e1)
end
function c9911309.filter(c,att)
	return c:GetOriginalAttribute()&att>0 and c:GetOriginalType()&TYPE_MONSTER>0 and (not c:IsOnField() or c:IsFaceup())
end
function c9911309.efcon(e)
	local c=e:GetHandler()
	local ct1=c:GetOverlayGroup():FilterCount(c9911309.filter,nil,ATTRIBUTE_FIRE)
	local ct2=c:GetEquipGroup():FilterCount(c9911309.filter,nil,ATTRIBUTE_FIRE)
	return ct1+ct2>0
end
function c9911309.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c9911309.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1=c:GetOverlayGroup():FilterCount(c9911309.filter,nil,ATTRIBUTE_WATER)
	local ct2=c:GetEquipGroup():FilterCount(c9911309.filter,nil,ATTRIBUTE_WATER)
	return ct1+ct2>0
end
function c9911309.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9911309.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack):Filter(Card.IsCanTurnSet,nil)
	if chk==0 then return #tg>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,1,0,0)
end
function c9911309.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack):Filter(Card.IsCanTurnSet,nil)
	if #tg==0 then return end
	if #tg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		tg=tg:Select(tp,1,1,nil)
	end
	Duel.HintSelection(tg)
	local tc=tg:GetFirst()
	if tc and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9911309,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT+RESET_PHASE+PHASE_END)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	end
end
