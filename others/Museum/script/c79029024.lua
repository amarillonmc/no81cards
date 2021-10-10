--罗德岛·先锋干员-格拉尼
function c79029024.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c79029024.lcheck)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029024,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029024)
	e1:SetCondition(c79029024.thcon)
	e1:SetTarget(c79029024.thtg)
	e1:SetOperation(c79029024.thop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029024,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19029024)
	e2:SetCondition(c79029024.negcon)
	e2:SetCost(c79029024.negcost)
	e2:SetTarget(c79029024.negtg)
	e2:SetOperation(c79029024.negop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,09029024)
	e3:SetCost(c79029024.spcost)
	e3:SetTarget(c79029024.sptg)
	e3:SetOperation(c79029024.spop)
	c:RegisterEffect(e3)
end
function c79029024.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xa900)
end
function c79029024.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) 
end
function c79029024.thfilter(c)
	return c:IsSetCard(0x1901) and c:IsAbleToHand()
end
function c79029024.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029024.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c79029024.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029024.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	Debug.Message("各位，让我们把胜利带回罗德岛！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029024,2))
	end
end
function c79029024.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c79029024.cfilter(c,rtype)
	return c:IsType(rtype) and c:IsAbleToGraveAsCost() and c:IsSetCard(0x1901)
end
function c79029024.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029024.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,rtype) end
	local g=Duel.SelectMatchingCard(tp,c79029024.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,rtype)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029024.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c79029024.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	Debug.Message("只要交锋就会决出胜负！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029024,4))
	end
end
function c79029024.ctfil(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_CYBERSE) and c:IsLinkAbove(3) and Duel.GetMZoneCount(tp,c)>0
end
function c79029024.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029024.ctfil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029024.ctfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c79029024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c79029024.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Debug.Message("以我的枪尖开路！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029024,3))
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then 
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029024,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.indoval)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)	
	end
end












