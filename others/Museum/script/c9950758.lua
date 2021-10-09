--抬头仰望的星空
function c9950758.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9950758.target)
	e1:SetOperation(c9950758.activate)
	c:RegisterEffect(e1)
end
function c9950758.filter(c,e,tp)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9950758.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9950758.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c9950758.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9950758.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,1-tp,2)
end
function c9950758.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(1-tp,2,REASON_EFFECT)
	Duel.BreakEffect()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)==0 then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(tc)
		e1:SetCondition(c9950758.descon)
		e1:SetOperation(c9950758.desop)
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(9950758,RESET_EVENT+RESETS_STANDARD,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c9950758.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
end
function c9950758.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(9950758)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c9950758.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c9950758.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
