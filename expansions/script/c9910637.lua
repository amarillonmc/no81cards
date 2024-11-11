--神械义体 重启者
function c9910637.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9910637)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9910637.thcost)
	e1:SetTarget(c9910637.thtg)
	e1:SetOperation(c9910637.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9910638)
	e2:SetCondition(c9910637.spcon)
	e2:SetTarget(c9910637.sptg)
	e2:SetOperation(c9910637.spop)
	c:RegisterEffect(e2)
end
function c9910637.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsPlayerAffectedByEffect(tp,9910682) and Duel.CheckLPCost(tp,2000)
	if chk==0 then return b1 or b2 end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(9910682,0))) then
		Duel.PayLPCost(tp,2000)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c9910637.thfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc954) and c:IsAbleToHand()
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c9910637.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9910637.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c9910637.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c9910637.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c9910637.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:IsPreviousPosition(POS_FACEUP)
end
function c9910637.mgfilter(c,e,tp,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsFaceupEx()
		and c:GetReason()&(REASON_FUSION+REASON_MATERIAL)==(REASON_FUSION+REASON_MATERIAL) and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and fusc:CheckFusionMaterial(mg,c,PLAYER_NONE,true)
end
function c9910637.spfilter(c,e,tp)
	if c:IsFaceup() and c:IsType(TYPE_FUSION) then
		local mg=c:GetMaterial()
		local ct=mg:GetCount()
		return ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
			and mg:FilterCount(c9910637.mgfilter,nil,e,tp,c,mg)==ct
			and (not Duel.IsPlayerAffectedByEffect(tp,59822133) or ct==1)
	else return false end
end
function c9910637.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910637.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910637.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c9910637.spfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	local mg=tc:GetMaterial()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#mg,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c9910637.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	if ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(c9910637.mgfilter,nil,e,tp,tc,mg)==ct
		and (not Duel.IsPlayerAffectedByEffect(tp,59822133) or ct==1) then
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end
