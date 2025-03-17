--恋慕屋敷的舞娘
function c9911060.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9911060.spcon)
	c:RegisterEffect(e1)
	--recycle
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,9911060)
	e2:SetCondition(c9911060.rccon)
	e2:SetCost(c9911060.rccost)
	e2:SetTarget(c9911060.rctg)
	e2:SetOperation(c9911060.rcop)
	c:RegisterEffect(e2)
end
function c9911060.spcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9954) and not c:IsRace(RACE_WINDBEAST)
end
function c9911060.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911060.spcfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c9911060.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9911060.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c9911060.rcfilter1(c,e)
	return c:IsCanBeEffectTarget(e) and (c:IsAbleToHand() or c:IsAbleToDeck())
end
function c9911060.rcfilter2(c)
	return c:IsFaceupEx() and c:IsSetCard(0x9954)
end
function c9911060.fselect(g,ct)
	return g:IsExists(c9911060.rcfilter2,1,nil) and g:IsExists(Card.IsAbleToHand,ct,nil) and g:IsExists(Card.IsAbleToDeck,3-ct,nil)
end
function c9911060.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dg=Duel.GetMatchingGroup(c9911060.rcfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,e)
	local b1=Duel.IsCanRemoveCounter(tp,1,1,0x1954,3,REASON_COST) and dg:CheckSubGroup(c9911060.fselect,3,3,1)
	local b2=Duel.IsCanRemoveCounter(tp,1,1,0x1954,6,REASON_COST) and dg:CheckSubGroup(c9911060.fselect,3,3,2)
	if chkc then return false end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return b1 or b2
	end
	local ct=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911060,0)},{b2,aux.Stringid(9911060,1)})
	Duel.RemoveCounter(tp,1,1,0x1954,ct*3,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=dg:SelectSubGroup(tp,c9911060.fselect,false,3,3,ct)
	Duel.SetTargetCard(g)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3-ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,3,0,0)
end
function c9911060.rcop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ct==0 or #tg==0 or aux.NecroValleyNegateCheck(tg) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=tg:FilterSelect(tp,Card.IsAbleToHand,ct,ct,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	tg:Sub(sg)
	if #tg>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
