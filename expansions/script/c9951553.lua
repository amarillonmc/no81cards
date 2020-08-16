--光之国·新乔尼亚斯
function c9951553.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9bd1),4,2)
	c:EnableReviveLimit()
 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951553,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9951553)
	e1:SetCondition(c9951553.spcon1)
	e1:SetTarget(c9951553.sptg1)
	e1:SetOperation(c9951553.spop1)
	c:RegisterEffect(e1)
 --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9951553.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c9951553.defval)
	c:RegisterEffect(e2)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951553.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
--cannot trigger
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0xa,0xa)
	e1:SetTarget(c9951553.distg)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetTarget(c9951553.distg)
	c:RegisterEffect(e2)
	--disable effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c9951553.disop)
	c:RegisterEffect(e3)
	--disable trap monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c9951553.distg)
	c:RegisterEffect(e4)
end
function c9951553.distg(e,c)
	return c:IsType(TYPE_SPELL)
end
function c9951553.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_SPELL) then
		Duel.NegateEffect(ev)
	end
end
function c9951553.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951553,0))
end
function c9951553.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bd1)
end
function c9951553.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9951553.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9951553.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9951553.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c9951553.atkfilter(c)
	return c:IsSetCard(0x9bd1) and c:GetAttack()>=0
end
function c9951553.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9951553.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c9951553.deffilter(c)
	return c:IsSetCard(0x9bd1) and c:GetDefense()>=0
end
function c9951553.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9951553.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end