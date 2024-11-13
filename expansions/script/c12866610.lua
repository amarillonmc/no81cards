--血之恶魔
function c12866610.initial_effect(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c12866610.splimit)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12866610)
	e1:SetCost(c12866610.spcost)
	e1:SetTarget(c12866610.sptg)
	e1:SetOperation(c12866610.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--summon reg
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c12866610.regop)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,12866611)
	e4:SetCondition(c12866610.tgcon)
	e4:SetTarget(c12866610.tgtg)
	e4:SetOperation(c12866610.tgop)
	c:RegisterEffect(e4)
end
function c12866610.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c12866610.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1800) end
	Duel.PayLPCost(tp,1800)
end
function c12866610.spfilter(c,e,tp)
	return c:IsSetCard(0x9a7c) and not c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12866610.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c12866610.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c12866610.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c12866610.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c12866610.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(12866610,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c12866610.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetFlagEffect(12866610)~=0
end
function c12866610.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsAbleToGrave() and not rc:IsLocation(LOCATION_GRAVE) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,rc,1,0,0)
end
function c12866610.tgop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	if rc:IsRelateToEffect(re) and Duel.SendtoGrave(rc,REASON_EFFECT)~=0 and not (c:IsRelateToEffect(e) or c:IsLocation(LOCATION_MZONE)) and Duel.IsChainNegatable(ev) and Duel.SelectYesNo(tp,aux.Stringid(12866610,2)) then
		Duel.NegateActivation(ev)
	end
end
