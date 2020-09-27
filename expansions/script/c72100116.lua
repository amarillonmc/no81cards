--彼岸的魔人 肥婆
function c72100116.initial_effect(c)
	aux.AddXyzProcedure(c,nil,3,2,c72100116.ovfilter,aux.Stringid(72100116,0),99,c72100116.xyzop)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
end
function c72100116.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb1) and not c:IsCode(72100116)
end
function c72100116.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,72100116)==0 end
	Duel.RegisterFlagEffect(tp,72100116,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end