--方舟骑士·破碎书页 真理
function c82567783.initial_effect(c)
	--Summon 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82567783,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,82567783)
	e1:SetCondition(c82567783.dwcon)
	e1:SetTarget(c82567783.dwtg)
	e1:SetOperation(c82567783.dwop)
	c:RegisterEffect(e1)
end
function c82567783.dwfilter(c)
	return c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567783.dwfilter2(c)
	return not c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567783.dwcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82567783.dwfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
		  and not Duel.IsExistingMatchingCard(c82567783.dwfilter2,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c82567783.dwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c82567783.dwop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end