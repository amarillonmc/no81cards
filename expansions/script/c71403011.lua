--气泡方块的星舰舰长 T
if not c71403001 then dofile("expansions/script/c71403001.lua") end
---@param c Card
function c71403011.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_PENDULUM),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--actlimit
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ep1:SetCode(EVENT_SPSUMMON_SUCCESS)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCondition(c71403011.actcon)
	ep1:SetOperation(c71403011.actop)
	c:RegisterEffect(ep1)
	local ep1a=Effect.CreateEffect(c)
	ep1a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ep1a:SetRange(LOCATION_PZONE)
	ep1a:SetCode(EVENT_CHAIN_END)
	ep1a:SetCondition(yume.PPTOtherScaleCheck)
	ep1a:SetOperation(c71403011.subop)
	c:RegisterEffect(ep1a)
	--change pos(p effect)
	local ep2=Effect.CreateEffect(c)
	ep2:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetDescription(aux.Stringid(71403011,0))
	ep2:SetCountLimit(1,71503011)
	ep2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ep2:SetCost(yume.PPTLimitCost)
	ep2:SetTarget(c71403011.tgp2)
	ep2:SetOperation(c71403011.opp2)
	c:RegisterEffect(ep2)
	--monster movement effect
	yume.RegPPTTetrisExMoveEffect(c,71403011)
	--change pos(monster effect)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71403011,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCountLimit(1,71513011)
	e2:SetCost(yume.PPTLimitCost)
	e2:SetTarget(c71403011.tg2)
	e2:SetOperation(c71403011.op2)
	c:RegisterEffect(e2)
	yume.PPTCounter()
end
c71403011.pendulum_level=4
function c71403011.actfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c71403011.actcon(e,tp,eg,ep,ev,re,r,rp)
	return yume.PPTOtherScaleCheck(e) and eg:IsExists(c71403011.actfilter,1,nil,tp)
end
function c71403011.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c71403011.chlimit)
	elseif Duel.GetCurrentChain()==1 then
		c:RegisterFlagEffect(71403011,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c71403011.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c71403011.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(71403011)
	e:Reset()
end
function c71403011.subop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(71403011)~=0 then
		Duel.SetChainLimitTillChainEnd(c71403011.chlimit)
	end
end
function c71403011.chlimit(e,ep,tp)
	return ep==tp
end
function c71403011.tgp2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tg=Duel.SelectTarget(tp,Card.IsCanChangePosition,0,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,#tg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c71403011.opp2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if tc:IsRelateToEffect(e)
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0
		and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE,1-tp)
	end
end
function c71403011.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		return c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT)
			and Duel.IsExistingMatchingCard(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			or Duel.IsExistingMatchingCard(c71403011.filter2,tp,LOCATION_ONFIELD,0,1,nil,true)
	end
	local g=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function c71403011.filter2(c,check)
	return c:IsFaceup() and c:IsSetCard(0x715)
		and (not check or Duel.IsExistingMatchingCard(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,c))
end
function c71403011.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt1=c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT)
	local opt2=Duel.IsExistingMatchingCard(c71403011.filter2,tp,LOCATION_ONFIELD,0,1,nil,false)
	local result=0
	if not opt1 and not opt2 then return end
	if opt1 and not opt2 then result=0 end
	if opt2 and not opt1 then result=1 end
	if opt1 and opt2 then result=Duel.SelectOption(tp,aux.Stringid(71403011,2),aux.Stringid(71403011,3)) end
	if result==0 then
		result=c:RemoveOverlayCard(tp,2,2,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c71403011.filter2,tp,LOCATION_ONFIELD,0,1,1,nil,false)
		Duel.HintSelection(dg)
		result=Duel.Destroy(dg,REASON_EFFECT)
	end
	if result==0 then return end
	local g=Duel.GetFieldGroup(0,LOCATION_MZONE,LOCATION_MZONE)
	local oppo_g=g:Filter(Card.IsControler,nil,1-tp)
	local seq_pos_table={}
	for tc in aux.Next(oppo_g) do
		seq_pos_table[tc:GetSequence()]=tc:GetPosition()
	end
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	local changed_g=Group.CreateGroup()
	local unchanged_g=Group.CreateGroup()
	for seq,pos in pairs(seq_pos_table) do
		local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq)
		if tc then
			if tc:GetPosition()==pos then
				unchanged_g:AddCard(tc)
			else
				changed_g:AddCard(tc)
			end
		end
	end
	if changed_g:GetCount()>0 then
		for tc in aux.Next(changed_g) do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		Duel.SendtoGrave(unchanged_g,REASON_RULE,1-tp)
	end
end