--集结！陷阱风暴
local cm,m=GetID()
function c71500006.initial_effect(c)
			local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.stfilter(c)
	return c:IsSSetable() and not c:IsForbidden() and c:IsType(TYPE_TRAP)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0  end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,cm.stfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(cm.target)
	e1:SetValue(cm.indct)
	Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.condition1)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetCondition(cm.actcon1)
	e3:SetValue(cm.aclimit)
	Duel.RegisterEffect(e3,tp)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(cm.checkcon)
	e5:SetOperation(cm.checkop)
	Duel.RegisterEffect(e5,tp)
	
	local e10=Effect.CreateEffect(e:GetHandler())
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetCondition(cm.spcon)
	e10:SetOperation(cm.spop)
	Duel.RegisterEffect(e10,tp)
	local e11=e10:Clone()
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(e11,tp)
	local e12=e10:Clone()
	e12:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	Duel.RegisterEffect(e12,tp)
		local e14=Effect.CreateEffect(c)
		e14:SetType(EFFECT_TYPE_FIELD)
		e14:SetCode(EFFECT_SET_ATTACK_FINAL)
		e14:SetTargetRange(LOCATION_MZONE,0)
		e14:SetValue(0)
	Duel.RegisterEffect(e14,tp)
	local e15=e14:Clone()
	e15:SetCode(EFFECT_SET_DEFENSE_FINAL)
	Duel.RegisterEffect(e15,tp)
	end
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_MONSTER)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.fit(c)
	return c:GetType()&TYPE_EFFECT~=0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and eg:IsExists(cm.fit,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetTarget(cm.limittg)
	e6:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e6,tp)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e7,tp)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e8,tp)
end
function cm.target(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function cm.stfilter(c)
	return c:IsType(TYPE_TRAP) and not c:IsForbidden() and c:IsSSetable()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.IsPlayerCanNormalDraw(tp) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.stfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 end
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not aux.IsPlayerCanNormalDraw(tp) then return end
	aux.GiveUpNormalDraw(e,tp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.stfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,2,2,nil)
			Duel.SSet(tp,sg)
		local tc=sg:GetFirst()
		while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
		end
end
function cm.actcon1(e)
	local tp=e:GetHandlerPlayer()
	local n=Duel.GetFlagEffect(tp,m)
	if n==nil then return false end
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_MONSTER)
end
function cm.limittg(e,c,sump,sumtype,sumpos,targetp)
	return c:GetOriginalType()&TYPE_EFFECT>0
end
