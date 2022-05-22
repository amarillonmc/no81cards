--圣殿剑骑 理查德
function c33200623.initial_effect(c)
	c:EnableReviveLimit()

		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_ADJUST)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetRange(LOCATION_MZONE)
		e0:SetLabel(1)
		e0:SetOperation(c33200623.txtop)
		c:RegisterEffect(e0)

	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200623,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,33200623)
	e1:SetCondition(c33200623.srcon)
	e1:SetTarget(c33200623.acttg)
	e1:SetOperation(c33200623.actop)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetCondition(c33200623.effcon2)
	c:RegisterEffect(e2)
	--attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200623,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1)
	e3:SetCondition(c33200623.effcon4)
	e3:SetTarget(c33200623.attg)
	e3:SetOperation(c33200623.atop)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetCondition(c33200623.effcon6)
	e4:SetOperation(c33200623.disop)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c33200623.effcon8)
	e5:SetValue(c33200623.efilter)
	c:RegisterEffect(e5)
end

--e1
function c33200623.actfilter(c,tp)
	return c:IsCode(33200619) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c33200623.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c33200623.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200623.actfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
end
function c33200623.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c33200623.actfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end

--e2
function c33200623.confilter(c)
	return c:IsSetCard(0x5329) and c:IsType(TYPE_MONSTER)
end
function c33200623.effcon2(e)
	local g=Duel.GetMatchingGroup(c33200623.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=2
end

function c33200623.effcon4(e)
	local g=Duel.GetMatchingGroup(c33200623.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=4
end

function c33200623.effcon6(e)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c33200623.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=6 and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end

function c33200623.effcon8(e)
	local g=Duel.GetMatchingGroup(c33200623.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=8
end

--e3
function c33200623.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return c:IsAttackable()
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)

end
function c33200623.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackable() and c:IsControler(tp) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc=g:GetFirst()
		if tc:IsControler(1-tp) and tc:IsRelateToEffect(e) then
			Duel.CalculateDamage(c,tc)
		end
	end
end

--e4
function c33200623.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c33200623.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c33200623.disecon)
		e2:SetOperation(c33200623.diseop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c33200623.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c33200623.disecon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33200623.diseop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

--e5
function c33200623.efilter(e,te)
	local tp=e:GetHandlerPlayer()
	return te:GetOwnerPlayer()==1-tp
end

--txt
function c33200623.txtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c33200623.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	local cod=g:GetClassCount(Card.GetCode)
	if e:GetLabel()~=cod then
		c:ResetFlagEffect(33200620)
		c:ResetFlagEffect(33200621)
		c:ResetFlagEffect(33200622)
		c:ResetFlagEffect(33200623)
		if cod>=2 then c:RegisterFlagEffect(33200620,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33200623,2)) end
		if cod>=4 then c:RegisterFlagEffect(33200621,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33200623,3)) end
		if cod>=6 then c:RegisterFlagEffect(33200622,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33200623,4)) end
		if cod>=8 then c:RegisterFlagEffect(33200623,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33200623,5)) end
		e:SetLabel(cod)
	end
end