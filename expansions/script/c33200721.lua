--苍岚水师战舰 海神号
function c33200721.initial_effect(c)
	c:EnableCounterPermit(0x32a)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200721,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,33200722)
	e2:SetCost(c33200721.countcost) 
	e2:SetTarget(c33200721.counttg)
	e2:SetOperation(c33200721.counter)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200721,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,33200721)
	e3:SetCost(c33200721.thcost)	
	e3:SetTarget(c33200721.thtg)
	e3:SetOperation(c33200721.thop)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c33200721.desreptg)
	e4:SetOperation(c33200721.desrepop)
	c:RegisterEffect(e4)
end

--e2
function c33200721.countcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200721.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c33200721.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c33200721.counttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetHandler(),0,0x32a)
end
function c33200721.cfilter(c)
	return c:IsSetCard(0xc32a) and c:IsDiscardable(REASON_COST)
end
function c33200721.counter(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x32a,2)
	end
end

--e3
function c33200721.thfilter(c)
	return c:IsSetCard(0xc32a) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c33200721.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x32a,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x32a,2,REASON_COST)
end
function c33200721.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200721.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c33200721.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33200721.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

--e4
function c33200721.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE)
		and e:GetHandler():IsCanRemoveCounter(tp,0x32a,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(33200721,2))
end
function c33200721.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x32a,1,REASON_EFFECT)
end
