--个人行动-爆破回收
function c79029242.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c79029242.cost)
	e1:SetTarget(c79029242.target)
	e1:SetOperation(c79029242.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c79029242.hcon)
	c:RegisterEffect(e2)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c79029242.dacost)
	e3:SetTarget(c79029242.datg)
	e3:SetOperation(c79029242.daop)
	c:RegisterEffect(e3)
end
function c79029242.cfil(c)
	return not c:IsType(TYPE_TOKEN) 
end
function c79029242.hcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) and not Duel.IsExistingMatchingCard(c79029242.cfil,tp,LOCATION_MZONE,0,1,nil)
end
function c79029242.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029242.hfil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029242.hfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)  
end
function c79029242.hfil(c)
	return c:IsType(TYPE_TOKEN) and (c:IsRace(RACE_MACHINE) or c:IsRace(RACE_CYBERSE))
end
function c79029242.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,0)
end
function c79029242.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RULE)
	Debug.Message("身体破损的话，再造一个就好了！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029242,0))
end
function c79029242.dacost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c79029242.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_TOKEN) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_TOKEN)	
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,nil,tp,0)
end
function c79029242.daop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local x=Duel.Destroy(g,REASON_EFFECT)
	Duel.Damage(1-tp,800*x,REASON_EFFECT)
	Debug.Message("呜哇！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029242,1))
end	







