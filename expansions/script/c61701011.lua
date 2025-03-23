--黑森林的逃亡鸟
function c61701011.initial_effect(c)
	aux.AddCodeList(c,61701001)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,61701011+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c61701011.sprcon)
	e1:SetOperation(c61701011.sprop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,61701011)
	e2:SetCost(c61701011.drcost)
	e2:SetTarget(c61701011.drtg)
	e2:SetOperation(c61701011.drop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,61701012+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c61701011.spcon)
	e3:SetOperation(c61701011.spop)
	c:RegisterEffect(e3)
end
function c61701011.ctfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function c61701011.chkfilter(c)
	return not c:IsCode(61701011) and c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function c61701011.sprcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c61701011.ctfilter,tp,LOCATION_MZONE,0,nil)>=Duel.GetMatchingGroupCount(c61701011.ctfilter,tp,0,LOCATION_MZONE,nil) and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c61701011.chkfilter,tp,LOCATION_HAND,0,1,nil)
end
function c61701011.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c61701011.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c61701011.disfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsDiscardable()
end
function c61701011.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61701011.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c61701011.disfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c61701011.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c61701011.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c61701011.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c61701011.splimit(e,c)
	return (c:IsLevelAbove(1) or not (c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK))) and c:IsLocation(LOCATION_EXTRA)
end
function c61701011.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,0,1,nil,61701001) and Duel.GetMZoneCount(tp)>0
end
function c61701011.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	c:RegisterEffect(e1,true)
end
