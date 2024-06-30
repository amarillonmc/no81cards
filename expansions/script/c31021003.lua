--反Antonymph's Attack Guard
function c31021003.initial_effect(c)
	--Summon Proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCondition(c31021003.spcon)
	e1:SetCountLimit(1,31021003)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c31021003.addcon)
	e2:SetTarget(c31021003.addtg)
	e2:SetOperation(c31021003.addop)
	e2:SetCountLimit(1,31021004)
	c:RegisterEffect(e2)
end
function c31021003.spfilter(c,ft,tp)
	return c:IsSetCard(0x893) and c:IsFaceup() and ft>0
end
function c31021003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return Duel.IsExistingMatchingCard(c31021003.spfilter,tp,LOCATION_MZONE,0,1,nil,ft,tp)
end

function c31021003.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c31021003.addfilter(c)
	return c:IsSetCard(0x1893) and c:IsType(TYPE_MONSTER) and (not c:IsCode(31021003)) and c:IsAbleToHand()
end
function c31021003.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31021003.addfilter,tp,LOCATION_DECK,nil,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,nil,0,0)
end
function c31021003.addop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c31021003.addfilter,tp,LOCATION_DECK,nil,nil)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
end