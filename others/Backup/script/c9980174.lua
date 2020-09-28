--魔法纪录·元气之深月菲莉希亚
function c9980174.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,6)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c9980174.lcheck)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c9980174.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980174,3))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9980174)
	e1:SetCondition(c9980174.thcon)
	e1:SetTarget(c9980174.thtg)
	e1:SetOperation(c9980174.thop)
	c:RegisterEffect(e1)
	--extra pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9980174,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,99801740)
	e5:SetCost(c9980174.expcost)
	e5:SetTarget(c9980174.exptg)
	e5:SetOperation(c9980174.expop)
	c:RegisterEffect(e5)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980174.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
c9980174.counter_add_list={0x1}
function c9980174.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980174,4))
end 
function c9980174.lcheck(g,lc)
	return g:IsExists(c9980174.mzfilter,1,nil)
end
function c9980174.mzfilter(c)
	return c:IsSetCard(0x3bc4) 
end
function c9980174.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbc4)
end
function c9980174.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c9980174.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c9980174.expcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,6,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,6,REASON_COST)
end
function c9980174.exptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9980174)==0 end
end
function c9980174.expop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980174,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,9980174,RESET_PHASE+PHASE_END,0,1)
end
function c9980174.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9980174.thfilter(c)
	return ((c:IsLocation(LOCATION_PZONE)) or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM)) 
		or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_PENDULUM))) and c:IsAbleToHand()
end
function c9980174.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9980174.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980174.thfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9980174.thfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,LOCATION_MZONE,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c9980174.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==2 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end