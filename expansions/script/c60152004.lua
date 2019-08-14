--魂火的余烬 佐仓杏子
function c60152004.initial_effect(c)
	--sp
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e12:SetRange(LOCATION_HAND)
	e12:SetCondition(c60152004.spcon2)
	e12:SetOperation(c60152004.spop2)
	c:RegisterEffect(e12)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60152004,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,60152004)
    e1:SetCondition(c60152004.con)
	e1:SetTarget(c60152004.target)
	e1:SetOperation(c60152004.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60152004,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,6012004)
    e3:SetCondition(c60152004.con)
    e3:SetOperation(c60152004.activate2)
    c:RegisterEffect(e3)
end
function c60152004.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c60152004.spfilter2(c)
	return ((c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER)) 
		or (c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_FIRE))) and c:IsReleasable()
end
function c60152004.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 then 
		return Duel.IsExistingMatchingCard(c60152004.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
			and Duel.IsExistingMatchingCard(c60152004.spfilter2,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsExistingMatchingCard(c60152004.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
	end
end
function c60152004.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c60152004.spfilter2,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		local tc2=g:GetFirst()
		while tc2 do
			if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
			tc2=g:GetNext()
		end
		Duel.Release(g,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g1=Duel.SelectMatchingCard(tp,c60152004.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
		local tc=g1:GetFirst()
		while tc do
			if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
			tc=g1:GetNext()
		end
		Duel.Release(g1,REASON_COST)
	end
end
function c60152004.dfilter(c)
    return c:IsFaceup() and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
		and not c:IsDisabled()
end
function c60152004.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152004.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c60152004.dfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c60152004.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c60152004.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c60152004.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        if Duel.Release(g,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g2=Duel.SelectMatchingCard(tp,c60152004.dfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g2:GetCount()>0 then
				Duel.HintSelection(g2)
				local tc=g2:GetFirst()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_SET_ATTACK_FINAL)
				e3:SetValue(0)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e3)
			end
		end
    end
end
function c60152004.activate2(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetTarget(aux.TargetBoolFunction(c60152004.filter2))
    e1:SetValue(c60152004.atkval)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c60152004.filter2(c)
	return ((c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER)) 
		or (c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_FIRE)))
end
function c60152004.atkfilter(c)
    return c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER)
end
function c60152004.atkval(e,c)
    return Duel.GetMatchingGroupCount(c60152004.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*300
end