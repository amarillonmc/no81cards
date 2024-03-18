--地狱使者比尔姬
local m=60159914
local cm=c60159914
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.dcon1)
	e1:SetOperation(cm.dop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetProperty(0)
	e2:SetCondition(cm.dcon2)
	e2:SetOperation(cm.rg)
	c:RegisterEffect(e2)
	if not cm.chk then
		cm.chk=true
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetCondition(cm.dcon3)
		e3:SetOperation(cm.dop3)
		Duel.RegisterEffect(e3,0)
	end
	
    --activate cost
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_ACTIVATE_COST)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(0,1)
    e4:SetCondition(c60159914.descon)
    e4:SetTarget(c60159914.actarget)
    e4:SetCost(c60159914.costchk)
    e4:SetOperation(c60159914.costop)
    c:RegisterEffect(e4)
    --activate cost
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_ACTIVATE_COST)
    e5:SetRange(LOCATION_MZONE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetTargetRange(0,1)
    e5:SetCondition(c60159914.descon)
    e5:SetTarget(c60159914.actarget2)
    e5:SetCost(c60159914.costchk2)
    e5:SetOperation(c60159914.costop2)
    c:RegisterEffect(e5)
end
function cm.dcon1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.dcon2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.dcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,m)>0 or Duel.GetFlagEffect(1,m)>0
end
function cm.dop3(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local n0=Duel.GetFlagEffect(p,m)
	local n1=Duel.GetFlagEffect(1-p,m)
	while n0>0 do
		cm.dop(e,p,eg,ep,ev,re,r,rp)
		Duel.ResetFlagEffect(p,m)
		n0=n0-1
	end
	while n1>0 do
		cm.dop(e,1-p,eg,ep,ev,re,r,rp)
		Duel.ResetFlagEffect(1-p,m)
		n1=n1-1
	end
end
function cm.rg(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	--local table=require('table')
	if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)<=0 then return end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<=0 then return end
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,hg)
		local t1=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_HAND,nil,TYPE_MONSTER)
		local t2=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_HAND,nil,TYPE_SPELL)
		local t3=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_HAND,nil,TYPE_TRAP)
		local g1=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
		local g3=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
		local chk1=g1:GetCount()*t1>0
		local chk2=g2:GetCount()*t2>0
		local chk3=g3:GetCount()*t3>0
		local op={}
		if chk1 then table.insert(op,aux.Stringid(m,0)) end
		if chk2 then table.insert(op,aux.Stringid(m,1)) end
		if chk3 then table.insert(op,aux.Stringid(m,2)) end
		if op=={} then return end
		local s=Duel.SelectOption(tp,table.unpack(op))
		if s==0 then
            if chk1 then cm.cop(tp,g1,t1,1)
            elseif chk2 then cm.cop(tp,g2,t2,2)
            else cm.cop(tp,g3,t3,3) end
        elseif s==1 then
            if not (chk1 and chk2) then cm.cop(tp,g3,t3,3)
            else cm.cop(tp,g2,t2,2) end
        else cm.cop(tp,g3,t3,3) end
    Duel.ShuffleHand(1-tp)
end
function cm.cop(tp,g,ct,act)
	Duel.Hint(HINT_SELECTMSG,tp,cm.tb[act])
	local sg=g:Select(tp,1,ct,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		if act==1 then
			Duel.Destroy(sg,REASON_EFFECT)
		elseif act==2 then
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		else
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end 
end
cm.tb={[1]=HINTMSG_DESTROY,[2]=HINTMSG_REMOVE,[3]=HINTMSG_TODECK}

function c60159914.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c60159914.actarget(e,te,tp)
    return te:GetHandler():IsType(TYPE_MONSTER)
end
function c60159914.cfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c60159914.costchk(e,te_or_c,tp)
    return Duel.IsExistingMatchingCard(c60159914.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
end
function c60159914.costop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,60159914)
    local g=Duel.SelectMatchingCard(tp,c60159914.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60159914.actarget2(e,te,tp)
    return te:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60159914.cfilter2(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c60159914.costchk2(e,te_or_c,tp)
    return Duel.IsExistingMatchingCard(c60159914.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
end
function c60159914.costop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,60159914)
    local g=Duel.SelectMatchingCard(tp,c60159914.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end