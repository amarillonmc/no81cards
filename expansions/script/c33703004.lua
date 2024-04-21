--动物朋友 雪兔
local m=33703004
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(FFECT_FLAG_DAMAGE_STEP)
	e1:SetCost(cm.costa)
	e1:SetTarget(cm.tga)
	e1:SetOperation(cm.opa)
	c:RegisterEffect(e1)
	--Effect 2  
	local e02=Effect.CreateEffect(c)  
	e02:SetCategory(CATEGORY_RECOVER)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_GRAVE)
	--e02:SetCountLimit(1,m)
	e02:SetCondition(aux.exccon)
	e02:SetCost(cm.costb)
	--e02:SetTarget(cm.tgb)
	e02:SetOperation(cm.opb)
	c:RegisterEffect(e02)  
	--all
end
--
function cm.sf(c) 
	return c:IsSetCard(0x442)
end 
--Effect 1
function cm.costa(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.cf(c)
	return c:IsFaceup() and cm.sf(c) 
end
function cm.tga(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cf,tp,LOCATION_MZONE,0,1,nl) end
end
function cm.opa(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.cf,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do  
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetDescription(aux.Stringid(m,0))
		e11:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e11:SetCode(EVENT_BATTLE_DAMAGE)
		e11:SetRange(LOCATION_MZONE)
		e11:SetCondition(cm.hdcon)
		e11:SetOperation(cm.hdop)
		e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e11,true)
	end 
end
function cm.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and eg:GetFirst()==e:GetHandler()
end
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end
--Effect 2
function cm.costb(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.opb(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.filter(c)
	local ck1=bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)~=0 or c:IsType(TYPE_MONSTER)
	return c:IsPreviousSetCard(0x442) and ck1
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter,nil)
	local val=g:GetSum(Card.GetAttack)
	if val==0 then return end
	Duel.Recover(tp,val,REASON_EFFECT)
end