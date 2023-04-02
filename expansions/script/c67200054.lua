--创刻-仙崎美来『浴血之时』
function c67200054.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c67200054.ctcon)
	e2:SetTarget(c67200054.cttg)
	e2:SetOperation(c67200054.ctop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200054,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,67200054)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c67200054.thtg)
	e3:SetOperation(c67200054.thop)
	c:RegisterEffect(e3)
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(c67200054.handcon)
	c:RegisterEffect(e4)
end
function c67200054.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x673)
end
function c67200054.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200054.ctfilter,1,nil,tp)
end
function c67200054.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1673)
end
function c67200054.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1673,1)
end
--
function c67200054.thfilter1(c,tp)
	local lv=c:GetLeftScale()
	return (c:IsLocation(LOCATION_DECK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and lv>0 and c:IsSetCard(0x673)
		and Duel.IsCanRemoveCounter(tp,1,1,0x1673,lv,REASON_COST) and c:IsAbleToHand()
end
function c67200054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200054.thfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c67200054.thfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tp)
	local lvt={}
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLeftScale()
		lvt[tlv]=tlv
		tc=g:GetNext()
	end
	local pc=1
	for i=1,13 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200054,1))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.RemoveCounter(tp,1,1,0x1673,lv,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c67200054.thfilter2(c,lv)
	return (c:IsLocation(LOCATION_DECK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsSetCard(0x673)
		and c:GetLeftScale()==lv and c:IsAbleToHand()
end
function c67200054.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200054.thfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67200054.cfilter11(c)
	return c:IsFaceup() and c:IsSetCard(0x673) and c:IsType(TYPE_FUSION)
end
function c67200054.handcon(e)
	return Duel.IsExistingMatchingCard(c67200054.cfilter11,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

