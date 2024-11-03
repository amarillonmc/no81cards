local m=15005088
local cm=_G["c"..m]
cm.name="反问·三终渊之绝望"
function cm.initial_effect(c)
	aux.EnableChangeCode(c,15005077)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xcf3e),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),2,99,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.indcon)
	e1:SetOperation(cm.indop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.atkcon)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
	--facedown banish
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(cm.rmcost)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
end
function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and g:IsExists(Card.IsSetCard,3,nil,0xcf3e)
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.atkfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.atkfilter,1,nil)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=eg:FilterCount(cm.atkfilter,nil)
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(ct*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.rmfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.rmfilter(chkc,tp) and chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) end
	local ct=math.floor(e:GetHandler():GetAttack()/1200)
	local g=Duel.GetDecktopGroup(tp,ct)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==ct and Duel.IsExistingTarget(cm.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,tp)
	end
	local rg=Duel.GetDecktopGroup(tp,ct)
	Duel.DisableShuffleCheck()
	local ct2=Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectTarget(tp,cm.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct2,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,0,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
end