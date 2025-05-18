--人理之基 南丁格尔
function c22022960.initial_effect(c)
	--special summon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022960,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(aux.damcon1)
	e1:SetTarget(c22022960.sptg1)
	e1:SetOperation(c22022960.spop1)
	c:RegisterEffect(e1)
	--avoid damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c22022960.damval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22022960,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,22022960)
	e4:SetCondition(c22022960.spcon)
	e4:SetTarget(c22022960.target)
	e4:SetOperation(c22022960.operation)
	c:RegisterEffect(e4)
	--special summon ere
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22022960,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,22022960)
	e5:SetCondition(c22022960.erecon)
	e5:SetCost(c22022960.erecost)
	e5:SetTarget(c22022960.target)
	e5:SetOperation(c22022960.operation)
	c:RegisterEffect(e5)
end
function c22022960.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c22022960.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.NegateEffect(ev)
	end
end
function c22022960.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function c22022960.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c22022960.filter(c,e,tp)
	return c:IsSetCard(0xff1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22022960.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c22022960.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22022960.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22022960.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22022960.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22022960.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980) and Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c22022960.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end