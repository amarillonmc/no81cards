--猩 红 庭 院 的 绅 士
local m=22348257
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnableDualAttribute(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348257,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(aux.IsDualState)
	e1:SetOperation(c22348257.actop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348257,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c22348257.condition)
	e3:SetOperation(c22348257.actop)
	c:RegisterEffect(e3)
	--change race
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(aux.IsDualState)
	e4:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e4)
	--atkup
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(500)
	c:RegisterEffect(e5)
	--atkup
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_LEVEL)
	e6:SetValue(2)
	c:RegisterEffect(e6)
end
function c22348257.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.dsercon(e) and c:IsDualState()
end
function c22348257.filter(c)
	return c:CheckActivateEffect(false,true,false)~=nil and ((c:GetType()==0x20002 and c:IsSetCard(0xa70a) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (c:GetType()==0x20004 and c:IsSetCard(0xa70a) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (c:GetType()==0x80002 and c:IsCode(22348260)))
end
function c22348257.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetOperation(c22348257.actop0)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE_START)
	Duel.RegisterEffect(e1,tp)
end
function c22348257.actop0(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348257)
	if not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c22348257.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348257.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and tc:GetType()==0x80002 then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end