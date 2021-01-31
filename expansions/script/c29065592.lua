--方舟骑士·暴行
function c29065592.initial_effect(c)
	c:SetSPSummonOnce(29065592)
	c:EnableCounterPermit(0x87ae)
	--link summon
	aux.AddLinkProcedure(c,c29065592.mfilter,1,1)
	c:EnableReviveLimit()  
	--COUNTER
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(29065592)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c29065592.con)
	c:RegisterEffect(e2)   
end
function c29065592.mfilter(c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x87af)
end
function c29065592.con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFlagEffect(tp,29065592)<=0
end







