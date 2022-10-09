--魔狱之领主 恋慕骑士
function c9911069.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c9911069.mfilter1,c9911069.mfilter2,true)
	c:EnableReviveLimit()
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c9911069.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--to deck/set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9911069.tdtg)
	e3:SetOperation(c9911069.tdop)
	c:RegisterEffect(e3)
end
function c9911069.mfilter1(c)
	return c:IsFusionSetCard(0x9954) and c:IsLevel(6)
end
function c9911069.mfilter2(c)
	return c:GetCounter(0x1954)>0 and c:IsFusionType(TYPE_EFFECT)
end
function c9911069.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1954)*-100
end
function c9911069.tdfilter(c)
	if not (c:IsSetCard(0x9954) and c:IsType(TYPE_SPELL+TYPE_TRAP)) then return false end
	return c:IsAbleToDeck() or c:IsSSetable()
end
function c9911069.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9911069.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911069.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9911069.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c9911069.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsAbleToDeck() and (not tc:IsSSetable() or Duel.SelectOption(tp,aux.Stringid(9911069,0),1153)==0) then
			if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK)
				and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(9911069,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
				Duel.HintSelection(tg)
				Duel.SendtoGrave(tg,REASON_EFFECT)
			end
		else
			Duel.SSet(tp,tc)
		end
	end
end
