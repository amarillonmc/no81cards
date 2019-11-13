function c119799730.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_CHAIN_END+TIMING_END_PHASE)
	e1:SetCountLimit(1,119799730+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c119799730.condition)
	e1:SetTarget(c119799730.target)
	e1:SetOperation(c119799730.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e4)
end
function c119799730.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c119799730.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c119799730.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c119799730.rfilter(c)
	return c:IsSetCard(0x306e) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c119799730.filter1(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c119799730.filter2(c)
	return not c:IsPosition(POS_FACEUP_ATTACK) or c:IsCanTurnSet()
end
function c119799730.filter3(c)
	return c:IsAbleToRemove()
end
function c119799730.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a1=Duel.IsExistingMatchingCard(c119799730.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler())
	local a2=Duel.IsExistingMatchingCard(c119799730.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local a3=Duel.IsExistingMatchingCard(c119799730.filter3,tp,0,LOCATION_ONFIELD,1,nil)
	local b1=Duel.IsExistingMatchingCard(c119799730.rfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c119799730.rfilter,tp,LOCATION_GRAVE,0,2,nil)
	local b3=Duel.IsExistingMatchingCard(c119799730.rfilter,tp,LOCATION_GRAVE,0,3,nil)
	if chk==0 then return (a1 and b1) or (a2 and b2) or (a3 and b3) end
	local op=0
	local off=1
	local ops={}
	local opval={}
	if a1 and b1 then
		ops[off]=aux.Stringid(119799730,0)
		opval[off-1]=1
		off=off+1
	end
	if a2 and b2 then
		ops[off]=aux.Stringid(119799730,1)
		opval[off-1]=2
		off=off+1
	end
	if a3 and b3 then
		ops[off]=aux.Stringid(119799730,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c119799730.rfilter,tp,LOCATION_GRAVE,0,sel,sel,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND)
		local m1=Duel.GetMatchingGroup(c119799730.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,m1,1,0,0)
	elseif sel==2 then
		e:SetCategory(CATEGORY_POSITION)
		local m2=Duel.GetMatchingGroup(c119799730.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,m2,1,0,0)
	else
		e:SetCategory(CATEGORY_REMOVE)
		local m3=Duel.GetMatchingGroup(c119799730.filter3,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,m3,1,0,0)
	end
end
function c119799730.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.SelectMatchingCard(tp,c119799730.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g2=Duel.SelectMatchingCard(tp,c119799730.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tc=g2:GetFirst()
		if tc then
			Duel.HintSelection(g2)
			if tc:IsPosition(POS_FACEUP_ATTACK) then
				Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			elseif tc:IsPosition(POS_FACEDOWN_DEFENSE) then
				Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
			else
				local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
				Duel.ChangePosition(tc,pos)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=Duel.SelectMatchingCard(tp,c119799730.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g3:GetCount()>0 then
			Duel.HintSelection(g3)
			Duel.Remove(g3,POS_FACEUP,REASON_EFFECT)
		end
	end
end