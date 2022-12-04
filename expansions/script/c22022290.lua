--千紫万红·神便鬼毒
function c22022290.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,5,c22022290.ovfilter,aux.Stringid(22022290,0),5,c22022290.xyzop)
	c:EnableReviveLimit()
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c22022290.sumcon)
	e2:SetOperation(c22022290.sumsuc)
	c:RegisterEffect(e2)
end
function c22022290.cfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1009)>0 and c:IsAbleToRemoveAsCost()
end
function c22022290.ovfilter(c)
	return c:IsFaceup() and c:IsCode(22022280)
end
function c22022290.xyzop(e,tp,chk)
	local g=Duel.GetMatchingGroup(c22022290.cfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SelectOption(tp,aux.Stringid(22022290,1))
	Duel.SelectOption(tp,aux.Stringid(22022290,2))
	Duel.SelectOption(tp,aux.Stringid(22022290,3))
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22022290.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c22022290.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end