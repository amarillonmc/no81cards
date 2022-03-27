--天罗水将 兰布罗斯
function c33200734.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xc32a),3)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200734,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,33200734)
	e1:SetCondition(c33200734.condition)
	e1:SetTarget(c33200734.thtg)
	e1:SetOperation(c33200734.thop)
	c:RegisterEffect(e1)
	--spsm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200734,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,33200735)
	e2:SetTarget(c33200734.rmtg)
	e2:SetOperation(c33200734.rmop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200734,2))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,33200736)
	e3:SetCondition(c33200734.ccon)
	e3:SetTarget(c33200734.ctg)
	e3:SetOperation(c33200734.cop)
	c:RegisterEffect(e3)   
end

--e1
function c33200734.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c33200734.thfilter(c)
	return c:IsSetCard(0xc32a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33200734.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200734.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c33200734.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33200734.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--e2
function c33200734.rmfilter1(c)
	return c:IsAbleToRemove()
end
function c33200734.rmfilter2(c)
	return c:IsSetCard(0xc32a) and c:IsAbleToRemove()
end
function c33200734.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200734.rmfilter1,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c33200734.rmfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c33200734.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c33200734.rmfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c33200734.rmfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end
	if g2:GetCount()>0 then
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
	end
end

--e3
function c33200734.ccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c33200734.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x32a,2)
end
function c33200734.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c33200734.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200734.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,c33200734.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x32a)
end
function c33200734.cop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x32a,2)
	end
end
