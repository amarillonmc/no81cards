--魔餐茶壶
function c51930010.initial_effect(c)
	c:EnableReviveLimit()
	--ritual
	local e1=aux.AddRitualProcEqual2(c,c51930010.rfilter,LOCATION_HAND+LOCATION_GRAVE,nil,c51930010.mfilter,true)
	e1:SetDescription(1168)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(0)
	e1:SetCountLimit(1,51930010)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c51930010.rscost)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,51930011)
	e2:SetCondition(c51930010.drcon)
	e2:SetTarget(c51930010.drtg)
	e2:SetOperation(c51930010.drop)
	c:RegisterEffect(e2)
end
function c51930010.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
end
function c51930010.rfilter(c,e,tp,chk)
	return c~=e:GetHandler()
end
function c51930010.mfilter(c,e,tp,chk)
	return c:IsSetCard(0x5258)
end
function c51930010.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c51930010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c51930010.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
