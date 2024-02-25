--绰 影 废 墟 的 穿 刺 陷 阱
local m=22348359
local cm=_G["c"..m] 
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
--  e1:SetCost(c22348359.cost)
	e1:SetTarget(c22348359.target)
	e1:SetOperation(c22348359.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--act in hand
--  local e3=Effect.CreateEffect(c)
--  e3:SetType(EFFECT_TYPE_SINGLE)
--  e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
--  e3:SetCondition(c22348359.handcon)
--  c:RegisterEffect(e3)
	--banish replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(22348359)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,22348359)
	c:RegisterEffect(e4)
	--changeffect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_REMOVE)
	e5:SetCondition(c22348359.cecon)
	e5:SetOperation(c22348359.ceop)
	c:RegisterEffect(e5)
	
end
function c22348359.cecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_REPLACE) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard(0x970a)
end
function c22348359.ceop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	tc:RegisterFlagEffect(22348359,RESET_CHAIN,0,1,1)
end
function c22348359.costfilter(c)
	return c:IsSetCard(0x970a) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c22348359.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
	if chk==0 then return Duel.IsExistingMatchingCard(c22348359.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,c22348359.costfilter,1,1,REASON_COST+REASON_DISCARD)
	else
	if chk==0 then return true end
	end
end
function c22348359.handcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0 and Duel.IsExistingMatchingCard(c22348359.costfilter,tp,LOCATION_HAND,0,1,c)
end
function c22348359.filter(c,tp)
	return c:IsSummonPlayer(1-tp) and (c:IsAbleToGrave() or c:IsCanTurnSet())
end
function c22348359.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c22348359.filter,1,nil,tp) end
	local g=eg:Filter(c22348359.filter,nil,tp)
	Duel.SetTargetCard(g)
end
function c22348359.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local off=1
	local ops={}
	local opval={}
	if g:IsExists(Card.IsCanTurnSet,1,nil) then
		ops[off]=aux.Stringid(22348359,0)
		opval[off-1]=1
		off=off+1
	end
	if g:IsExists(Card.IsAbleToGrave,1,nil) then
		ops[off]=aux.Stringid(22348359,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(1-tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)


	elseif opval[op]==2 then
		Duel.SendtoGrave(g,REASON_RULE,1-tp)
	end
end


