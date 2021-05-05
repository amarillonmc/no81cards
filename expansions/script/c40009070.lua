--苍岚龙 灾漩
function c40009070.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009070,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40009070)
	e1:SetOperation(c40009070.atkop1)
	c:RegisterEffect(e1)   
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009070,1))
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1)
	e2:SetCost(c40009070.thcost)
	e2:SetCondition(c40009070.condition)
	e2:SetOperation(c40009070.atkop)
	c:RegisterEffect(e2)
end
function c40009070.check(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if Duel.GetBattledCount(tp) then
		c40009070[tc:GetControler()]=c40009070[tc:GetControler()]+1
		if c40009070[tc:GetControler()]==1 then
			c40009070[2]=tc
			tc:RegisterFlagEffect(40009070,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		elseif c40009070[tc:GetControler()]==2 or c40009070[tc:GetControler()]==3 then
			Duel.RaiseEvent(tc,EVENT_CUSTOM+40009070,e,0,0,0,0)
		end
	end
end
function c40009070.check2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffect(40009070)~=0 and Duel.GetAttacker()==tp then
		c40009070[tc:GetControler()]=c40009070[tc:GetControler()]+1
	end
end
function c40009070.clear(e,tp,eg,ep,ev,re,r,rp)
	c40009070[0]=0
	c40009070[1]=0
end
function c40009070.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(600)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c40009070.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattledCount(tp)==2 or Duel.GetBattledCount(tp)==1 
end
function c40009070.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c40009070.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
end