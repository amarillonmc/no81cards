--Kingprotea
function c69131401.initial_effect(c)
	c:EnableCounterPermit(0xe69)
	c:SetCounterLimit(0xe69,10) 
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69131401,0))
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1,69131401)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c69131401.cttg)
	e1:SetOperation(c69131401.ctop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19131401)
	e2:SetCost(c69131401.stcost)
	e2:SetTarget(c69131401.sttg)
	e2:SetOperation(c69131401.stop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69131401,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,29131401)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCondition(c69131401.atkcon)
	e3:SetTarget(c69131401.atktg)
	e3:SetOperation(c69131401.atkop)
	c:RegisterEffect(e3)
end
function c69131401.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c69131401.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==tp end
end
function c69131401.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
	c:AddCounter(0xe69,2)
	Duel.Recover(tp,c:GetCounter(0xe69)*1000,REASON_EFFECT)
	end
end
function c69131401.stfil(c)
	return (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)) and c:IsSSetable()
end
function c69131401.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xe69,e:GetHandler():GetCounter(0xe69),REASON_COST) and e:GetHandler():GetCounter(0xe69)>=8 end
	e:GetHandler():RemoveCounter(tp,0xe69,e:GetHandler():GetCounter(0xe69),REASON_COST)
end
function c69131401.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69131401.stfil,tp,LOCATION_DECK,0,2,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=2 end
end
function c69131401.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c69131401.stfil,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	while tc do 
	Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
end
function c69131401.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and aux.dscon()  
end
function c69131401.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0xe69)>0 end
end
function c69131401.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetCounter(0xe69)*1000
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	Duel.BreakEffect()
	Duel.Damage(tp,atk/2,REASON_EFFECT)
end