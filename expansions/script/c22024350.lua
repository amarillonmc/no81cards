--人理异星 梵·高
function c22024350.initial_effect(c)
	c:EnableReviveLimit()
	--fusion summon
	aux.AddFusionProcFunRep(c,c22024350.ffilter,2,true)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22024350,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c22024350.cost1)
	e1:SetTarget(c22024350.atktg)
	e1:SetOperation(c22024350.atkop)
	c:RegisterEffect(e1)
	--DISABLE
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22024350,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c22024350.spcon)
	e3:SetCost(c22024350.cost2)
	e3:SetTarget(c22024350.distg)
	e3:SetOperation(c22024350.disop)
	c:RegisterEffect(e3)
	--Can not Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22024350,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c22024350.spcon1)
	e4:SetCost(c22024350.cost3)
	e4:SetTarget(c22024350.cantg)
	e4:SetOperation(c22024350.canop)
	c:RegisterEffect(e4)

	--atkdown ere
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22024350,3))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCondition(c22024350.erecon)
	e5:SetCost(c22024350.erecost1)
	e5:SetTarget(c22024350.atktg)
	e5:SetOperation(c22024350.atkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--DISABLE
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22024350,4))
	e7:SetCategory(CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCondition(c22024350.erespcon)
	e7:SetCost(c22024350.erecost2)
	e7:SetTarget(c22024350.distg)
	e7:SetOperation(c22024350.disop)
	c:RegisterEffect(e7)
	--Can not Activate
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(22024350,5))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetCondition(c22024350.erespcon1)
	e8:SetCost(c22024350.erecost3)
	e8:SetTarget(c22024350.cantg)
	e8:SetOperation(c22024350.canop)
	c:RegisterEffect(e8)
end
function c22024350.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22024351)==0 end
	c:RegisterFlagEffect(22024351,RESET_CHAIN,0,1)
end
function c22024350.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22024352)==0 end
	c:RegisterFlagEffect(22024352,RESET_CHAIN,0,1)
end
function c22024350.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22024353)==0 end
	c:RegisterFlagEffect(22024353,RESET_CHAIN,0,1)
end
function c22024350.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0xff1) and (not sg or not sg:IsExists(Card.IsRace,1,c,c:GetRace()))
end
function c22024350.atkfilter(c,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP) and c:IsAttackAbove(1) or c:IsDefenseAbove(1)
end
function c22024350.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c22024350.atkfilter,1,e:GetHandler(),1-tp) end
	local g=eg:Filter(c22024350.atkfilter,e:GetHandler(),1-tp)
	Duel.SetTargetCard(g)
end
function c22024350.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain():Filter(Card.IsFaceup,nil)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c22024350.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA)
end
function c22024350.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22024350.cfilter,1,nil,1-tp)
end
function c22024350.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c22024350.atkfilter,1,e:GetHandler(),1-tp) end
	local g=eg:Filter(c22024350.atkfilter,e:GetHandler(),1-tp)
	Duel.SetTargetCard(g)
end
function c22024350.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain():Filter(Card.IsFaceup,nil)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c22024350.cfilter1(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_GRAVE+LOCATION_REMOVED)
end
function c22024350.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22024350.cfilter1,1,nil,1-tp)
end
function c22024350.cantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c22024350.atkfilter,1,e:GetHandler(),1-tp) end
	local g=eg:Filter(c22024350.atkfilter,e:GetHandler(),1-tp)
	Duel.SetTargetCard(g)
end
function c22024350.canop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain():Filter(Card.IsFaceup,nil)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(22024350,2))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c22024350.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22024350.erecost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22024351)==0 end
	c:RegisterFlagEffect(22024351,RESET_CHAIN,0,1)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22024350.erecost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22024352)==0 end
	c:RegisterFlagEffect(22024352,RESET_CHAIN,0,1)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22024350.erecost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22024353)==0 end
	c:RegisterFlagEffect(22024353,RESET_CHAIN,0,1)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22024350.erespcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22024350.cfilter,1,nil,1-tp) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22024350.erespcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22024350.cfilter1,1,nil,1-tp)
end