--六世壊苦滅道聖諦
function c71201960.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,71201960)
	e1:SetTarget(c71201960.target)
	e1:SetOperation(c71201960.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,18884367)
	e1:SetCondition(c71201960.con)
	e2:SetTarget(c71201960.tg)
	e2:SetOperation(c71201960.op)
	c:RegisterEffect(e2)
end
function c71201960.filter1(c,e)
	return c:IsFaceup() and c:IsSetCard(0x189) and c:IsCanBeEffectTarget(e)
end
function c71201960.filter2(c,e)
	return c:IsCanBeEffectTarget(e)
end
function c71201960.cfilter1(c)
	return c:IsFaceup() and c:IsCode(73542331)
end
function c71201960.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c71201960.filter1,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),e)
		and Duel.IsExistingTarget(c71201960.filter2,tp,0,LOCATION_ONFIELD,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c71201960.filter1,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),e)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c71201960.filter2,tp,0,LOCATION_ONFIELD,1,1,nil,e)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
end
function c71201960.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) 
		and lc:IsRelateToEffect(e) and lc:IsControler(1-tp) then
		if Duel.IsExistingMatchingCard(c71201960.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(71201960,1)) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			Duel.Remove(lc,POS_FACEDOWN,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			Duel.Remove(lc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c71201960.thfilter(c)
	return c:IsSetCard(0x189) and c:IsAbleToHand()
end
function c71201960.cfilter2(c)
	return c:IsSetCard(0x189) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c71201960.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c71201960.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c71201960.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71201960.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71201960.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71201960.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
