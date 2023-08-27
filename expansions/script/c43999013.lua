--地狱恶魔的极端支配
local m=43999013
local cm=_G["c"..m]
function cm.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0) 
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c43999013.cost)
	e1:SetTarget(c43999013.target)
	e1:SetOperation(c43999013.activate)
	c:RegisterEffect(e1)
	--apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43999013,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,43999013)
--  e2:SetCondition(c43999013.effcon)
	e2:SetTarget(c43999013.efftg)
	e2:SetOperation(c43999013.effop)
	c:RegisterEffect(e2)
	--change effect type
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(43999013)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	c43999013.SetCard_diyuemo=true
end
function c43999013.costfilter(c)
	return c.SetCard_diyuemo and c:IsAbleToRemoveAsCost()
end
function c43999013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	local bool=e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND)
	if chk==0 then return Duel.IsExistingMatchingCard(c43999013.costfilter,tp,LOCATION_HAND,0,1,c) or not c:IsLocation(LOCATION_HAND) end
	if bool then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c43999013.costfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c43999013.acfilter(c,tp)
	return c:IsCode(94585852) and c:GetActivateEffect():IsActivatable(tp)
end
function c43999013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43999013.acfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c43999013.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c43999013.acfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end




function c43999013.effcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler().SetCard_diyuemo
end
function c43999013.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c.SetCard_diyuemo and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove())
	then return false end
	local te=c.onfield_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c43999013.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if chk==0 then return (not (g:GetCount()==1 and g:GetFirst():IsCode(22348136)) and
	Duel.IsExistingMatchingCard(c43999013.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp))
	or((g:GetCount()==1 and g:GetFirst():IsCode(22348136)) and
	Duel.IsExistingMatchingCard(c43999013.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,g,e,tp,eg,ep,ev,re,r,rp))
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_MZONE)
end
function c43999013.effop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if g:GetCount()==1 and g:GetFirst():IsCode(22348136) then
	local tg=Duel.SelectMatchingCard(tp,c43999013.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,g,e,tp)
	local tc=tg:GetFirst()
	local te=tc.onfield_effect
	local op=te:GetOperation()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and op then op(e,tp,eg,ep,ev,re,r,rp) end
	else
	local tg=Duel.SelectMatchingCard(tp,c43999013.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=tg:GetFirst()
	local te=tc.onfield_effect
	local op=te:GetOperation()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end

