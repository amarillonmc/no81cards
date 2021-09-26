--战源龙 人心幻化
local m=35300203
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,cm.retfilter1,cm.retfilter2,true)
	--change race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(0xff)
	e1:SetValue(RACE_WARRIOR)
	c:RegisterEffect(e1)
	--mudeki
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(cm.atktg)
	e5:SetValue(cm.efilter)
	c:RegisterEffect(e5)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.negcon)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+1)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.retfilter1(c)
	return c:IsLevelAbove(3) and c:IsRace(RACE_WARRIOR) 
end
function cm.retfilter2(c)
	return c:IsLevelAbove(4) and c:IsRace(RACE_DRAGON) 
end

function cm.atktg(e,c)
	return c:IsLevelBelow(4)
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end

function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return (re:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) or re:GetActivateLocation()==LOCATION_HAND or re:GetActivateLocation()==LOCATION_GRAVE or re:GetActivateLocation()==LOCATION_REMOVED) and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end

function cm.spfilter(c,att)
	return c:IsType(TYPE_SYNCHRO)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,1-tp,0,LOCATION_MZONE,1,nil) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_SYNCHRO)
		c:RegisterEffect(e1)
	end
end