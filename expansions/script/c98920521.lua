--拓扑战士
function c98920521.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98920521.dmcon)
	e1:SetValue(c98920521.efilter)
	c:RegisterEffect(e1)
	 --battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c98920521.dmcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--move
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(98920521,0))
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetTarget(c98920521.seqtg)
	e11:SetOperation(c98920521.seqop)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e12:SetCost(c98920521.cost)
	e12:SetCondition(c98920521.condition)
	c:RegisterEffect(e12)
	 --atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920521,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920521.atkcon)
	e2:SetTarget(c98920521.atktg)
	e2:SetOperation(c98920521.atkop)
	c:RegisterEffect(e2)
end
function c98920521.filter(c,ec)
	return c:IsFaceup() and c:IsLinkAbove(3) and c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK) and (c:GetLinkedGroup():IsContains(ec) or ec:GetLinkedGroup():IsContains(c))
end
function c98920521.dmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c98920521.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c,ec)
end
function c98920521.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c98920521.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c98920521.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=c:GetControler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(sg) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	if c:IsControler(tp) then
	   local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	   Duel.Hint(HINT_ZONE,tp,fd)
	   local seq=math.log(fd,2)
	   Duel.MoveSequence(c,seq)
	else
	   local fd=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	   Duel.Hint(HINT_ZONE,tp,fd)
	   local seq=math.log(bit.rshift(fd,16),2)
	   Duel.MoveSequence(c,seq)
	end	
	local pseq=c:GetSequence()	
end
function c98920521.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()~=tp
end
function c98920521.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c98920521.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup()
end
function c98920521.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetLabelObject():CreateEffectRelation(e)
end
function c98920521.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(c98920521.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-g:GetSum(Card.GetLink)*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c98920521.atkfilter(c,ec)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(ec)
end