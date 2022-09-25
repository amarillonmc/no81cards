--深空 众神之殿
function c72101207.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72101207+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)

	--fang zhishiwu tongzhao
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c72101207.zswop)
	c:RegisterEffect(e2)
	--fang zhishiwu tezhao
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	--shen weifengkangxing
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetValue(1)
	e4:SetCondition(c72101207.godcon)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	
	--shijia xiaoguo
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(72101207)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(1,1)
	c:RegisterEffect(e6)

end

--fang zhishiwu
function c72101207.zswfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:GetOriginalAttribute()==ATTRIBUTE_DIVINE) and c:IsSetCard(0xcea)
end
function c72101207.zswop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c72101207.zswfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x7210,ct,true)
	end
end

--shen weifengkangxing
function c72101207.sfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0xcea) and c:IsAttribute(ATTRIBUTE_DIVINE)
end
function c72101207.godcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72101207.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
