--罗德岛·术士干员-阿米娅
function c79029037.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029037.lzcon)
	e1:SetTarget(c79029037.lztg)
	e1:SetOperation(c79029037.lzop)
	c:RegisterEffect(e1)	
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c79029037.val)
	c:RegisterEffect(e2) 
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetOperation(c79029037.checkop)
	c:RegisterEffect(e0)
end
function c79029037.atkfilter(c)
	return c:IsSetCard(0x1901)
end
function c79029037.val(e,c)
	local g=Duel.GetMatchingGroup(c79029037.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	local ct=g:GetCount()
	return ct*800
end
function c79029037.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79029037.drfilter(c)
	return c:IsSetCard(0xa900) and c:IsDiscardable()
end
function c79029037.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029037.drfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c79029037.lzop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029037.drfilter,tp,LOCATION_HAND,0,1,1,nil)
	local gc=g:GetFirst()
	local lv=gc:GetLevel()
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.DiscardDeck(tp,lv,REASON_EFFECT)
end
function c79029037.spfilter(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(6)
end
function c79029037.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c79029037.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	local tg=Duel.SelectMatchingCard(tp,c79029037.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
end
end
