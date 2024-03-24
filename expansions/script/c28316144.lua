--闪耀的黑彗星 斑鸠路加
function c28316144.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--CoMETIK spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28316144,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,28316144)
	e1:SetCondition(c28316144.spcon)
	e1:SetTarget(c28316144.sptg)
	e1:SetOperation(c28316144.spop)
	c:RegisterEffect(e1)
	--luka spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28316144,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,28316144)
	e2:SetCondition(c28316144.lkcon)
	e2:SetTarget(c28316144.sptg)
	e2:SetOperation(c28316144.spop)
	c:RegisterEffect(e2)
	--CoMETIK to deck-luka
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28316144,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,38316144)
	e3:SetTarget(c28316144.tdtg)
	e3:SetOperation(c28316144.tdop)
	c:RegisterEffect(e3)
end
function c28316144.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_REMOVED) and re:GetHandler():IsSetCard(0x283) and e:GetHandler():IsReason(REASON_EFFECT)
end
function c28316144.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(0x283) and c:IsFaceup()
end
function c28316144.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28316144.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c28316144.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28316144.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,c)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and ct>0 then
		local lv=c:GetLevel()
		if ct>=lv then ct=lv-1 end
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_LEVEL)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		e0:SetValue(-ct)
		c:RegisterEffect(e0)
	end
end
function c28316144.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x283) and c:IsAbleToDeck()
end
function c28316144.cefilter(c)
	return c:IsFaceup() and c:IsCode(28335405) and c:IsAbleToDeck()
end
function c28316144.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c28316144.tdfilter(chkc) end
	local b1=Duel.IsExistingTarget(c28316144.tdfilter,tp,LOCATION_REMOVED,0,2,nil)
	local b2=Duel.IsExistingTarget(c28316144.cefilter,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return b1 or b2 end
	if not b2 or (b1 and Duel.SelectYesNo(tp,aux.Stringid(28316144,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c28316144.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c28316144.cefilter,tp,LOCATION_REMOVED,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c28316144.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(28316144,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if tc then
			Duel.HintSelection(tc)
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
