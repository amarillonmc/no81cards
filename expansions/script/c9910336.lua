--神树勇者的辟路
function c9910336.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910336+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910336.target)
	e1:SetOperation(c9910336.operation)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c9910336.reptg)
	e2:SetValue(c9910336.repval)
	c:RegisterEffect(e2)
end
function c9910336.attfilter(c)
	return c:IsFaceup() and c:GetAttribute()~=0
end
function c9910336.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910336.attfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return aux.GetAttributeCount(g)>0 end
end
function c9910336.filter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c9910336.spfilter(c,e,tp)
	return c:IsSetCard(0x3956) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(c9910336.filter,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
function c9910336.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910336.attfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=aux.GetAttributeCount(g)
	if ct==0 then return end
	local b1=ct>=1
	local b2=ct>=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910336.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(9910336,0))) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c9910336.actop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		b1=false
	end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(9910336,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c9910336.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9910336.actop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x3956,0x5956) and ep==tp then
		Duel.SetChainLimit(c9910336.chainlm)
	end
end
function c9910336.chainlm(e,rp,tp)
	return tp==rp
end
function c9910336.repfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x3956)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c9910336.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c9910336.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function c9910336.repval(e,c)
	return c9910336.repfilter(c,e:GetHandlerPlayer())
end
