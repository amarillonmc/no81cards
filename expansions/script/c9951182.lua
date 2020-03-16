--万圣节魔娘·机械伊丽莎白巨人
function c9951182.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c9951182.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),true)
 --Attribute Dark
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetValue(RACE_DRAGON)
	e2:SetRange(LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
	c:RegisterEffect(e2)
 --remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951182,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,9951182)
	e4:SetCondition(c9951182.rmcon)
	e4:SetTarget(c9951182.rmtg)
	e4:SetOperation(c9951182.rmop)
	c:RegisterEffect(e4)
 --return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951182,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c9951182.rettg)
	e2:SetOperation(c9951182.retop)
	c:RegisterEffect(e2)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951182.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951182.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951182,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951182,1))
end
function c9951182.ffilter(c)
	return c:IsSetCard(0x9ba8) and c:IsFusionType(TYPE_RITUAL)
end
function c9951182.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c9951182.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c9951182.rmop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c9951182.retfilter1(c)
	return c:IsSetCard(0xba5) and c:IsAbleToDeck()
end
function c9951182.retfilter2(c)
	return c:IsAbleToHand()
end
function c9951182.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9951182.retfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil)
		and Duel.IsExistingTarget(c9951182.retfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c9951182.retfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,c9951182.retfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function c9951182.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g1=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
	if Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local g2=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951182,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951182,1))
end