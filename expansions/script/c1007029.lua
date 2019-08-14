--现代魔术使·苍崎青子
function c1007029.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c1007029.addct)
	e1:SetOperation(c1007029.addc)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1007029,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2,107029)
	e3:SetCost(c1007029.cost)
	e3:SetTarget(c1007029.sptg)
	e3:SetOperation(c1007029.spop)
	c:RegisterEffect(e3)
	--th
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1007029,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(2,107029)
	e4:SetCost(c1007029.cost1)
	e4:SetTarget(c1007029.target)
	e4:SetOperation(c1007029.activate)
	c:RegisterEffect(e4)
	--th
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1007029,2))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(2,107029)
	e5:SetCondition(c1007029.czcon)
	e5:SetCost(c1007029.cost2)
	e5:SetTarget(c1007029.tg)
	e5:SetOperation(c1007029.op)
	c:RegisterEffect(e5)
end
function c1007029.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1245)
end
function c1007029.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1245,30)
	end
end
function c1007029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1245,10,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1245,10,REASON_COST)
end
function c1007029.spfilter(c,e,tp)
	return c:IsSetCard(0x20f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(1007029)
end
function c1007029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1007029.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c1007029.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1007029.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c1007029.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1245,20,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1245,20,REASON_COST)
end
function c1007029.filter(c)
	return c:IsSetCard(0x20f) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end
function c1007029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1007029.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1007029.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1007029.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1007029.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1245,30,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1245,30,REASON_COST)
end
function c1007029.cfilter12(c)
	return c:IsFaceup() and c:IsSetCard(0x20f) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c1007029.czcon(e)
	return Duel.IsExistingMatchingCard(c1007029.cfilter12,tp,LOCATION_SZONE,0,1,nil)
end
function c1007029.filter1(c)
	return c:IsAbleToGrave()
end
function c1007029.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1007029.filter1,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c1007029.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c1007029.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1007029.filter1,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Hint(HINT_CARD,0,1007029)
		Duel.SendtoGrave(g,REASON_RULE)
	end
end