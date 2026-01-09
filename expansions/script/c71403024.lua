--气泡方块的女中学生 安藤林檎
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	if not (yume and yume.PPT_loaded) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71403001,0)
		yume.import_flag=false
	end
	--syn summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_PENDULUM),aux.NonTuner(aux.FilterBoolFunction(Card.IsSynchroType,TYPE_PENDULUM)),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--chain limit
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ep1:SetCode(EVENT_CHAINING)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCondition(yume.PPTOtherScaleCheck)
	ep1:SetOperation(s.actop)
	c:RegisterEffect(ep1)
	--change pos(p effect)
	local ep2=Effect.CreateEffect(c)
	ep2:SetCategory(CATEGORY_POSITION)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetDescription(aux.Stringid(id,0))
	ep2:SetCountLimit(1,id+100000)
	ep2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ep2:SetCost(yume.PPTLimitCost)
	ep2:SetTarget(s.tgp2)
	ep2:SetOperation(s.opp2)
	c:RegisterEffect(ep2)
	--monster movement effect
	yume.RegPPTPuyopuyoExMoveEffect(c,id)
	--sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+110000)
	e2:SetCost(yume.PPTLimitCost)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:GetHandler():IsSetCard(0x715) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.filterp2(c)
	return c:IsFaceup() and yume.PPTPlacePendExceptFromFieldFilter(c)
end
function s.tgp2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE)
	end
	if chk==0 then
		return Duel.IsExistingTarget(nil,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(s.filterp2,tp,LOCATION_EXTRA,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.opp2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local b2=tc:IsCanChangePosition()
		local op=-1
		if b2 then
			op=Duel.SelectOption(tp,aux.Stringid(71403019,2),aux.Stringid(71403019,3))
		else
			op=Duel.SelectOption(tp,aux.Stringid(71403019,2))
		end
		local op_flag=false
		if op==0 then
			op_flag=Duel.Destroy(sg,REASON_EFFECT)>0
		else
			op_flag=Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0
		end
		local g=Duel.GetMatchingGroup(s.filterp2,tp,LOCATION_EXTRA,0,1,nil)
		if op_flag and g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local pc=g:Select(tp,1,1,nil):GetFirst()
			Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function s.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x715)
end
function s.qfilter(e,c)
	return c:IsSetCard(0x715)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA+LOCATION_ONFIELD,0,1,nil)
	end
	local g1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA+LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local desg=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA+LOCATION_ONFIELD,0,1,1,nil)
	if Duel.Destroy(desg,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetTargetRange(LOCATION_SZONE,0)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTarget(s.qfilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		Duel.RegisterEffect(e2,tp)
	end
end