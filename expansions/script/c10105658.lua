function c10105658.initial_effect(c)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
    	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105658,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10105658)
	e3:SetCondition(c10105658.descon)
	e3:SetTarget(c10105658.destg)
	e3:SetOperation(c10105658.desop)
	c:RegisterEffect(e3)
    	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10105658,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,101056580)
	e4:SetCondition(c10105658.condition)
	e4:SetTarget(c10105658.target)
	e4:SetOperation(c10105658.operation)
	c:RegisterEffect(e4)
end
function c10105658.desfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT)
end
function c10105658.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10105658.desfilter2,1,nil,tp)
end
function c10105658.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10105658.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0
		and c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end
function c10105658.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41
end
function c10105658.filter(c,e,tp)
	return c:IsCode(10105658)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10105658.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10105658.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10105658.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end