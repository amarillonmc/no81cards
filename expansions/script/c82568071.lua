--AK-炽钳手贾维
function c82568071.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82568071)
	e1:SetCost(c82568071.cost)
	e1:SetTarget(c82568071.target)
	e1:SetOperation(c82568071.operation)
	c:RegisterEffect(e1)
	--AddCounter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,82568171)
	e2:SetTarget(c82568071.cttg)
	e2:SetOperation(c82568071.ctop)
	c:RegisterEffect(e2)
	--AddCounter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,82568171)
	e3:SetTarget(c82568071.cttg)
	e3:SetOperation(c82568071.ctop)
	c:RegisterEffect(e3)
end
function c82568071.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568071.filter(c,e,tp)
	return c:IsSetCard(0x825) and c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82568071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568071.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_DECK)
end
function c82568071.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568071.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c82568071.tkfilter(c)
	return c:IsFaceup()
end
function c82568071.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c82568070.tkfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82568070.tkfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c82568071.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e)
	then tc:AddCounter(0x5825,1)
	Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
