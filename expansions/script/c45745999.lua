--传说训练师 阿渡
function c45745999.initial_effect(c)
	c:SetUniqueOnField(1,1,45745999)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c45745999.lcheck)  
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45745999,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,45745999)
	e1:SetCondition(c45745999.thcon)
	e1:SetTarget(c45745999.thtg)
	e1:SetOperation(c45745999.thop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_ONFIELD))
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	--cant link
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e5)

	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(45745999,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e6:SetCountLimit(1)
	e6:SetCondition(c45745999.eqcon)
	e6:SetTarget(c45745999.sptg)
	e6:SetOperation(c45745999.spop)
	c:RegisterEffect(e6)
end
function c45745999.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x881)
end
--e1
function c45745999.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c45745999.tgfilter(c)
	return c:IsSetCard(0x881) and c:IsAbleToGrave()
end
function c45745999.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45745999.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c45745999.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c45745999.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--e6
function c45745999.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c45745999.spfilter(c,e,tp)
	return c:IsSetCard(0x881) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c45745999.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c45745999.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function c45745999.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c45745999.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
