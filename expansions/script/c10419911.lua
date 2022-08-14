--暗金教
local m=10419911
local cm=_G["c"..m]
cm.named_with_Kabal=1
function cm.Kabal(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Kabal
end
function cm.Potion(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Potion
end

function cm.initial_effect(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--to hand
	--local e3=Effect.CreateEffect(c)
	--e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	--e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCode(EVENT_PHASE+PHASE_END)
	--e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	--e3:SetCost(cm.thcost)
	--e3:SetTarget(cm.thtg)
	--e3:SetOperation(cm.thop)
	--c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCost(cm.thcost2)
	e4:SetTarget(cm.thtg2)
	e4:SetOperation(cm.thop2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function cm.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
--function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
--  local g=Duel.GetReleaseGroup(tp)
--  if chk==0 then return g:GetCount()>0 end
--  Duel.Release(g,REASON_COST)
--end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.ntfilter(c)
	return c:IsFaceup() and cm.Potion(c)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.ntfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)and Duel.CheckReleaseGroup(tp,nil,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp)
	if g:GetCount()==0 or not c:IsRelateToEffect(e) then return end
	if Duel.Release(g,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.cfilter(c,tp)
	return cm.Kabal(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,c)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.filter(c)
	return cm.Potion(c) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.cfilter2(c,tp)
	return cm.Potion(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,c)
end
function cm.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.filter2(c)
	return c:IsAbleToHand() and cm.Kabal(c) and c:IsType(TYPE_MONSTER)
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

