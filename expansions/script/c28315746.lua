--闪耀的一等星 八宫巡
function c28315746.initial_effect(c)
	--illumination spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28315746,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28315746)
	e1:SetTarget(c28315746.sptg)
	e1:SetCost(c28315746.cost)
	e1:SetOperation(c28315746.spop)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	--spsummon-tuner
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28315746,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	--e2:SetCountLimit(1,28315746+1)
	e2:SetTarget(c28315746.spttg)
	e2:SetOperation(c28315746.sptop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c28315746.tdfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function c28315746.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and c28315746.tdfilter(chkc) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c28315746.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c28315746.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED+LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c28315746.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	local ct=0
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	end
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and ct>0 then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_LEVEL)
		e0:SetValue(ct)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e0)
	end
end
function c28315746.spfilter(c,e,tp,chk)
	return c:IsSetCard(0x283) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsType(TYPE_MONSTER)
end
function c28315746.spttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c28315746.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,0)
	end--Duel.IsPlayerAffectedByEffect(tp,59822133)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c28315746.sptop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	--local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c28315746.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,1):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and sc:IsSummonLocation(LOCATION_HAND) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(28315746,2)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c28315746.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFlagEffectLabel(tp,28315746) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,28315746,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,28315746,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+28318749,e,0,0,0,0)
end
