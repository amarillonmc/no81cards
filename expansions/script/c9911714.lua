--剑域修武士 蚀髓
function c9911714.initial_effect(c)
	--tribute from otherside
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911714,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c9911714.otcon)
	e1:SetOperation(c9911714.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,9911714)
	e3:SetCost(c9911714.rmcost)
	e3:SetTarget(c9911714.rmtg)
	e3:SetOperation(c9911714.rmop)
	c:RegisterEffect(e3)
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--redirect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCondition(c9911714.recon)
	e5:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e5)
end
function c9911714.tfilter(c)
	return (c:IsLocation(LOCATION_MZONE) or c:IsSetCard(0x9957)) and c:IsReleasable(REASON_SUMMON)
end
function c9911714.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c9911714.tfilter,tp,LOCATION_DECK,LOCATION_MZONE,nil)
	return c:IsLevelAbove(5) and minc<=1 and #g>0 and Duel.GetMZoneCount(tp)>0
end
function c9911714.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c9911714.tfilter,tp,LOCATION_DECK,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:Select(tp,1,1,nil)
	c:SetMaterial(sg)
	if sg:GetFirst():IsLocation(LOCATION_MZONE) then Duel.Release(sg,REASON_MATERIAL+REASON_SUMMON)
	else Duel.SendtoGrave(sg,REASON_RELEASE+REASON_MATERIAL+REASON_SUMMON) end
end
function c9911714.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x9957) end
	local sg=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x9957)
	Duel.Release(sg,REASON_COST)
end
function c9911714.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE)
end
function c9911714.thfilter(c)
	return c:IsSetCard(0x9957) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9911714.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if #tg>0 and Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)>0 then
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9911714.thfilter),tp,LOCATION_GRAVE,0,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9911714,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			sg=sg:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c9911714.recon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and not c:IsReason(REASON_RELEASE)
end
