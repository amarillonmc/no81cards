--次元逃逸魔法一号
function c44401021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCost(c44401021.cost)
	e1:SetTarget(c44401021.target)
	e1:SetOperation(c44401021.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetTarget(c44401021.reptg)
	e2:SetValue(c44401021.repval)
	e2:SetOperation(c44401021.repop)
	c:RegisterEffect(e2)
end
function c44401021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c44401021.cfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function c44401021.spfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0xa4a) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c44401021.cfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,math.floor(lv/2),nil) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c44401021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c44401021.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	--confirm
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local fc=Duel.SelectMatchingCard(tp,c44401021.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,fc)
	e:SetLabelObject(fc)
	--target
	local ct=math.floor(fc:GetLevel()/2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectTarget(tp,c44401021.cfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,fc,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,ct,tp,LOCATION_MZONE+LOCATION_REMOVED)
end
function c44401021.activate(e,tp,eg,ep,ev,re,r,rp)
	local fc=e:GetLabelObject()
	local g=Duel.GetTargetsRelateToChain()
	if Duel.SpecialSummon(fc,0,tp,tp,false,false,POS_FACEUP)~=0 and #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c44401021.repfilter(c,tp)
	return c:IsSetCard(0xa4a) and c:IsControler(tp) and c:IsOnField() and c:IsFaceup() and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c44401021.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and eg:IsExists(c44401021.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c44401021.repval(e,c)
	return c44401021.repfilter(c,e:GetHandlerPlayer())
end
function c44401021.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,44401021)
end
