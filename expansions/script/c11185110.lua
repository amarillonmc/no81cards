--星绘颂章
function c11185110.initial_effect(c)
	c:EnableCounterPermit(0x452)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,11185110+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)
	--Add Counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(3)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e11:SetCode(EVENT_CHAIN_SOLVED)
	e11:SetRange(LOCATION_FZONE)
	e11:SetOperation(c11185110.counterop)
	c:RegisterEffect(e11)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11185110,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,11185110+1)
	e2:SetCost(c11185110.thcost)
	e2:SetTarget(c11185110.thtg)
	e2:SetOperation(c11185110.thop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,11185110+2)
	e3:SetTarget(c11185110.reptg)
	e3:SetValue(c11185110.repval)
	e3:SetOperation(c11185110.repop)
	c:RegisterEffect(e3)
	--win
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetRange(LOCATION_FZONE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetOperation(c11185110.winop)
	c:RegisterEffect(e7)
end
function c11185110.counterop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 then
		e:GetHandler():AddCounter(0x452,1)
	end
end
function c11185110.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x452,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x452,3,REASON_COST)
end
function c11185110.thfilter(c)
	return c:IsCanHaveCounter(0x452) and c:IsAbleToHand()
end
function c11185110.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185110.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11185110.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11185110.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11185110.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c11185110.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c11185110.repfilter,1,nil,tp)
		and Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c11185110.repval(e,c)
	return c11185110.repfilter(c,e:GetHandlerPlayer())
end
function c11185110.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,0x452,1,REASON_EFFECT)
end
function c11185110.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON = 0x452
	local c=e:GetHandler()
	if Duel.GetCounter(tp,1,0,0x452)>=150 then
		Duel.Win(tp,WIN_REASON)
	end
end