GearGal=GearGal or {}
function GearGal.SpellZoneGearGalFilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1449)
end
function GearGal.NearGalSpecialSummonCondition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(GearGal.SpellZoneGearGalFilter,tp,LOCATION_SZONE,0,1,nil)
end
function GearGal.AddNearGalEffects(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,0x7449)
	e1:SetCondition(GearGal.NearGalSpecialSummonCondition)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_LINK_CODE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(33700300)
	c:RegisterEffect(e2)
end
function GearGal.PlaceAsContinuousSpell(c,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0
		or not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return false end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	c:RegisterEffect(e1)
	return true
end
function GearGal.NegateUntilEndPhase(c,source)
	local e1=Effect.CreateEffect(source)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	c:RegisterEffect(e2)
end
