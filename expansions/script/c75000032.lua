--里特司的神龙王 琉迩艾尔
function c75000032.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3751),aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),true)
-----
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000032,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75000032)
	e1:SetCondition(c75000032.spcon)
	e1:SetTarget(c75000032.sptg)
	e1:SetOperation(c75000032.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
------1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000032,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,75000033+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c75000032.discon)
	e2:SetTarget(c75000032.distg)
	e2:SetOperation(c75000032.disop)
	c:RegisterEffect(e2)
-----2
end

function c75000032.cfilter(c,tp)
	return c:IsFaceup() and (c:IsCode(75000001) or aux.IsCodeListed(c,75000001)) and c:IsControler(tp)
end
function c75000032.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c75000032.cfilter,1,nil,tp)
end
function c75000032.spfilter(c,e,tp)
	return c:IsSetCard(0x3751) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75000032.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c75000032.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c75000032.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c75000032.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c75000032.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
---------1
function c75000032.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x3751) and te:IsActiveType(TYPE_MONSTER) and p==tp and rp==1-tp
end
function c75000032.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c75000032.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
----------2