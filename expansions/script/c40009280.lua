--机械加工 破坏者
local m=40009280
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),3)
	--limit 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.econ)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,g)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,3,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,3,3,nil,lg)
	local ct=g:FilterCount(Card.IsType,nil,TYPE_NORMAL)
	e:SetValue(ct)
	if ct>0 then
		e:SetCategory(CATEGORY_DRAW)
	else
		e:SetCategory(0)
	end
	Duel.Release(g,REASON_COST)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsLocation(LOCATION_HAND)
end
function cm.op(e,tp)
	local ct=e:GetValue()
	if ct>0 and Duel.IsPlayerCanDraw(tp,ct) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(cm.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.ecfilter(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp)
end
function cm.econ(e)
	return not e:GetHandler():GetColumnGroup():IsExists(cm.ecfilter,1,nil,e:GetHandlerPlayer())
end
