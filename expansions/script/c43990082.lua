--旋转的发条三号线
local m=43990082
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c43990082.descon)
	e2:SetTarget(c43990082.destg)
	e2:SetOperation(c43990082.desop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,43980082)
	e3:SetTarget(c43990082.thtg)
	e3:SetOperation(c43990082.thop)
	c:RegisterEffect(e3)
	--release replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(43990082,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetTarget(c43990082.reptg)
	e4:SetValue(function(e,c) return c:GetFlagEffect(43990082)>0 end)
	c:RegisterEffect(e4)
	
end
function c43990082.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsRace(RACE_ILLUSION)
end
function c43990082.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c43990082.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c43990082.spfilter(c,e,tp)
	return c:IsSetCard(0x5510) and c:IsAbleToGrave()
end
function c43990082.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990082.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c43990082.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c43990082.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c43990082.filter2(c,re,tp,r)
	return bit.band(r,REASON_COST)~=0 and c:GetDestination()==LOCATION_GRAVE and c:IsType(TYPE_MONSTER) and re and aux.GetValueType(re)=="Effect" and re:IsActivated() and re:GetHandlerPlayer()==tp
end
function c43990082.rrfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c43990082.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return re and re:GetHandler():IsRace(RACE_ILLUSION) and eg:IsExists(c43990082.filter2,1,nil,re,tp,r) end
	if Duel.IsExistingMatchingCard(c43990082.rrfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43990082,1)) then
		local g=eg:Filter(c43990082.filter2,nil,re,tp,r)
		g:ForEach(Card.RegisterFlagEffect,43990082,RESET_CHAIN,0,1)
		local g2=Duel.SelectMatchingCard(tp,c43990082.rrfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g2,REASON_COST)
		return true
	else return false end
end

