--象征世界的编织
function c43990929.initial_effect(c)
	--leavl field
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVING)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCondition(c43990929.lfcon)
	e0:SetOperation(c43990929.lfop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43990929)
	e1:SetTarget(c43990929.target)
	e1:SetOperation(c43990929.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,43990929-1)
	e2:SetTarget(c43990929.reptg)
	e2:SetValue(c43990929.repval)
	e2:SetOperation(c43990929.repop)
	c:RegisterEffect(e2)
end
function c43990929.lfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and (not c:IsOnField() or not c:IsRelateToEffect(re))-- and re:IsActivated()
end
function c43990929.tgfilter(c)
	return c:IsSetCard(0x7a10) and c:IsAbleToGrave()
end
function c43990929.lfop(e,tp,eg,ep,ev,re,r,rp)
	--if not Duel.SelectYesNo(tp,aux.Stringid(43990929,2)) then return end
	Duel.Hint(HINT_CARD,0,43990929)
	Duel.Hint(HINT_SELECTMSG,rp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(rp,c43990929.tgfilter,rp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c43990929.spfilter(c,e,tp)
	return c:IsSetCard(0x7a10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43990929.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c43990929.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c43990929.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c43990929.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if sc then Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) end
end
function c43990929.repfilter(c,tp)
	return c:IsSetCard(0x7a10) and c:IsControler(tp) and c:IsOnField() and c:IsFaceup() and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c43990929.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and eg:IsExists(c43990929.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c43990929.repval(e,c)
	return c43990929.repfilter(c,e:GetHandlerPlayer())
end
function c43990929.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,43990929)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
