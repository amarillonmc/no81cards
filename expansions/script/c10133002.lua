--饥饿狼王
function c10133002.initial_effect(c)
	aux.EnableChangeCode(c,10133001,LOCATION_MZONE)
	aux.AddCodeList(c,10133001)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10133002.spcon)
	c:RegisterEffect(e1)
	--special summon 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10133002,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,10133002)
	e3:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e3:SetTarget(c10133002.target)
	e3:SetOperation(c10133002.operation)
	c:RegisterEffect(e3)
end
function c10133002.filter(c,tp)
	return Duel.GetMZoneCount(tp,c,tp) > 0 and (c:IsControler(tp) or Duel.IsExistingMatchingCard(c10133002.sprfilter,tp,LOCATION_ONFIELD,0,1,nil))
end
function c10133002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c = e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c10133002.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10133002.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10133002.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10133002.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c = e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT) > 0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10133002.spfilter(c,e,tp)
	return c:IsCode(10133001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10133002.sprfilter(c)
	return (c:IsCode(10133001) or (c:IsType(TYPE_FUSION) and c:IsSetCard(0x3334))) and c:IsFaceup()
end
function c10133002.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10133002.sprfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end