--人理嘘饰 阿瓦隆女士
function c22024490.initial_effect(c)
	c:EnableCounterPermit(0xfee)
	c:SetCounterLimit(0xfee,12)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5098),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22024490,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,22024490)
	e1:SetCondition(c22024490.thcon)
	e1:SetTarget(c22024490.thtg)
	e1:SetOperation(c22024490.thop)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22024490,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22024491)
	e2:SetCondition(c22024490.chcon)
	e2:SetCost(c22024490.cost3)
	e2:SetTarget(c22024490.chtg)
	e2:SetOperation(c22024490.chop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22024490,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c22024490.spcon)
	e3:SetTarget(c22024490.sptg)
	e3:SetOperation(c22024490.spop)
	c:RegisterEffect(e3)
end
c22024490.effect_with_avalon=true
function c22024490.ctfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER)
end
function c22024490.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c22024490.ctfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c22024490.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(c22024490.ctfilter,tp,LOCATION_GRAVE,0,c)
	local c=e:GetHandler()
	if chk==0 and ct>0 and ct<13 then return Duel.IsCanAddCounter(tp,0xfee,ct,c) end
	if chk==0 and ct>12 then return Duel.IsCanAddCounter(tp,0xfee,12,c) end
end
function c22024490.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c22024490.ctfilter,tp,LOCATION_GRAVE,0,c)
	if c:IsRelateToEffect(e) and ct>0 and ct<13 then
		c:AddCounter(0xfee,ct)
	end
	if c:IsRelateToEffect(e) and ct>12 then
		c:AddCounter(0xfee,12)
	end
end
function c22024490.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xfee,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xfee,3,REASON_COST)
end
function c22024490.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c22024490.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
end
function c22024490.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22024490.repop)
end
function c22024490.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Recover(1-tp,2000,REASON_EFFECT)
end
function c22024490.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c22024490.spfilter(c,e,tp)
	return c:IsSetCard(0xff1) and c:IsLevelBelow(10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c22024490.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22024490.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c22024490.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22024490.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
