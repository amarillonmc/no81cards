--机 神 伊 瑞 思
local m=22348033
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
--  local e1=Effect.CreateEffect(c)
--  e1:SetType(EFFECT_TYPE_FIELD)
--  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
--  e1:SetCode(EFFECT_SPSUMMON_PROC)
--  e1:SetRange(LOCATION_HAND)
--   e1:SetCondition(c22348033.sprcon)
--   e1:SetOperation(c22348033.sprop)
--  c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348033,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22348033)
	e2:SetCost(c22348033.decost)
	e2:SetCondition(c22348033.decon1)
	e2:SetTarget(c22348033.thtg)
	e2:SetOperation(c22348033.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c22348033.decon2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetRange(LOCATION_SZONE+LOCATION_MZONE)
	e4:SetCondition(c22348033.decon3)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetRange(LOCATION_SZONE+LOCATION_MZONE)
	e5:SetCondition(c22348033.decon4)
	c:RegisterEffect(e5)
	--act limit
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22348033,3))
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_HAND)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetCondition(c22348033.drcon1)
	e6:SetValue(c22348033.limval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetRange(LOCATION_SZONE+LOCATION_HAND)
	e7:SetCondition(c22348033.drcon2)
	c:RegisterEffect(e7)
	--send replace
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e8:SetCondition(c22348033.repcon)
	e8:SetOperation(c22348033.repop)
	c:RegisterEffect(e8)
end
function c22348033.filter(c)
	return not c:IsPublic()
end
function c22348033.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(c22348033.filter,tp,LOCATION_HAND,0,2,c) or (Duel.IsPlayerCanDiscardDeckAsCost(tp,2) and Duel.IsPlayerAffectedByEffect(tp,22348041)))
end
function c22348033.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local fe=Duel.IsPlayerAffectedByEffect(tp,22348041)
	if Duel.IsPlayerAffectedByEffect(tp,22348041) and not Duel.IsPlayerCanDiscardDeckAsCost(tp,2) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c22348033.filter,tp,LOCATION_HAND,0,2,2,c)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(22348030,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	elseif Duel.IsPlayerAffectedByEffect(tp,22348041) and not Duel.IsExistingMatchingCard(c22348033.filter,tp,LOCATION_HAND,0,2,c) then
	Duel.Hint(HINT_CARD,0,22348041)
	fe:UseCountLimit(tp)
	Duel.DiscardDeck(tp,2,REASON_COST)
	elseif Duel.IsPlayerAffectedByEffect(tp,22348041) and Duel.SelectYesNo(tp,aux.Stringid(22348041,4)) then
		Duel.Hint(HINT_CARD,0,22348041)
		fe:UseCountLimit(tp)
		Duel.DiscardDeck(tp,2,REASON_COST)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c22348033.filter,tp,LOCATION_HAND,0,2,2,c)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(22348030,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
end
function c22348033.decon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,22348037) and not Duel.IsPlayerAffectedByEffect(tp,22348038)
end
function c22348033.decon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,22348037) and Duel.IsPlayerAffectedByEffect(tp,22348038)
end
function c22348033.decon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22348037) and not Duel.IsPlayerAffectedByEffect(tp,22348038)
end
function c22348033.decon4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22348037) and Duel.IsPlayerAffectedByEffect(tp,22348038)
end

function c22348033.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348033.filter,tp,LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c22348033.filter,tp,LOCATION_HAND,0,2,2,nil)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(22348033,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c22348033.thfilter(c)
	return c:IsSetCard(0x700) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c22348033.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348033.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22348033.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348033.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22348033.drcon1(e)
	local c=e:GetHandler()
	return c:IsPublic() and not Duel.IsPlayerAffectedByEffect(tp,22348037)
end
function c22348033.drcon2(e)
	local c=e:GetHandler()
	return c:IsPublic() and Duel.IsPlayerAffectedByEffect(tp,22348037)
end
function c22348033.limval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and rc:IsSummonType(SUMMON_TYPE_NORMAL)
end
function c22348033.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY) and Duel.IsPlayerAffectedByEffect(tp,22348039)
end
function c22348033.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end




