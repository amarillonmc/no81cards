--式神·赤华花海 彼岸花
local m=96071054
local set=0xff7
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x18)
	--link summon
	aux.AddLinkProcedure(c,nil,2,nil,cm.lcheck)
	c:EnableReviveLimit()
	--cannot link material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.ctcost)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(cm.reptg)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
	--damage1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(cm.regop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.damcon)
	e4:SetOperation(cm.damop)
	c:RegisterEffect(e4)
	--damage2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.damcon1)
	e5:SetOperation(cm.damop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_TO_HAND)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.regcon)
	e6:SetOperation(cm.regop2)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EVENT_CHAIN_SOLVED)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(cm.damcon2)
	e7:SetOperation(cm.damop2)
	c:RegisterEffect(e7)
	--damage3
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(cm.damcon3)
	e8:SetOperation(cm.damop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(cm.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(cm.reset)
		Duel.RegisterEffect(ge2,0)
	end
end
	--link summon
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xff7)
end
	--counter
function cm.cffilter(c)
	return c:IsSetCard(0xff7) and not c:IsPublic()
end
function cm.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x18,1)
	end
end
	--destroy replace
function cm.repfilter(c,e)
	return c:IsSetCard(0xff7)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(cm.repfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,cm.repfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,e)
		Duel.SetTargetCard(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
	--damage1
function cm.regop1(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(m)~=0
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local ct=e:GetHandler():GetCounter(0x18)
	Duel.Damage(1-tp,ct*100,REASON_EFFECT)
end
	--damage2
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	cm.chain_solving=true
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm.chain_solving=false
end
function cm.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and not cm.chain_solving
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and cm.chain_solving
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	e:GetHandler():RegisterFlagEffect(96071055,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,ct)
end
function cm.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(96071055)>0
end
function cm.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local labels={e:GetHandler():GetFlagEffectLabel(96071055)}
	local ct=0
	for i=1,#labels do ct=ct+labels[i] end
	e:GetHandler():ResetFlagEffect(96071055)
	local ct=e:GetHandler():GetCounter(0x18)
	Duel.Damage(1-tp,ct*100,REASON_EFFECT)
end
	--damage3
function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function cm.damcon3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end