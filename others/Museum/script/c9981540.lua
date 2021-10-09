--假面驾驭·世界的破坏者
function c9981540.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9981540.spcon)
	c:RegisterEffect(e1)
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c9981540.atkup)
	c:RegisterEffect(e2)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981540,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c9981540.thtg)
	e1:SetOperation(c9981540.thop)
	c:RegisterEffect(e1)
	--cannot be targeted
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9981540)
	e2:SetTarget(c9981540.sptg)
	e2:SetOperation(c9981540.spop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981540.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981540.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981540,0))
end
function c9981540.atkfilter(c)
	return c:IsSetCard(0xbca) and c:IsType(TYPE_MONSTER)
end
function c9981540.atkup(e,c)
	return Duel.GetMatchingGroupCount(c9981540.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*300
end
function c9981540.filter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c9981540.thfilter(c,tp)
	return c:IsSetCard(0xbca) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(c9981540.filter,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
function c9981540.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981540.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9981540.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9981540.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9981540.spfilter(c)
	return c:IsSetCard(0xbca) and c:IsType(TYPE_MONSTER) and (not c:IsOnField() or c:IsFaceup())
end
function c9981540.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c9981540.spfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>8
end
function c9981540.tgfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbca) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c9981540.spfilter2(c,e,tp)
	return c:IsSetCard(0xbca) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9981540.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981540.tgfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c9981540.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9981540.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c9981540.tgfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
	local tc=tg:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9981540.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
