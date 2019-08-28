--ANOTHER RIDER DEN-O
function c65010310.initial_effect(c)
	  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65010310,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCountLimit(1,650103100)
	e1:SetCondition(c65010310.hspcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65010310,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP_ATTACK,0)
	e2:SetCountLimit(1,650103100)
	e2:SetCondition(c65010310.spcon2)
	c:RegisterEffect(e2)
	--cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65010310,2))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65010310)
	e1:SetCondition(c65010310.thcon)
	e1:SetTarget(c65010310.thtg)
	e1:SetOperation(c65010310.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c65010310.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c65010310.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(65010310,2))
end
function c65010310.cfilter(c)
	return c:GetColumnGroupCount()<1
end
function c65010310.hspcon(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(c65010310.cfilter,1-tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,1-tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp,LOCATION_REASON_TOFIELD,zone)<1 or Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function c65010310.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xcda0)
end
function c65010310.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65010310.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c65010310.cfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xcda0) 
end
function c65010310.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c65010310.cfilter1,1,nil)
end
function c65010310.spfilter(c,e,tp)
	return c:IsSetCard(0xcda0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c65010310.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=e:GetHandler():GetOwner()
	if chk==0 then return Duel.GetLocationCount(p,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c65010310.spfilter,p,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,p,LOCATION_DECK+LOCATION_GRAVE)
end
function c65010310.thop(e,tp,eg,ep,ev,re,r,rp)
	 local p=e:GetHandler():GetOwner()
	 if Duel.GetLocationCount(p,LOCATION_MZONE)<=0 then return end
	 Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
	 local g=Duel.SelectMatchingCard(p,c65010310.spfilter,p,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,p)
	 if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,p,p,false,false,POS_FACEUP)
	 end
end