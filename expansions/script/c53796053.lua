local m=53796053
local cm=_G["c"..m]
cm.name="邪恶的滋生"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.cfilter(c,re)
	return re and re:GetActiveType()==TYPE_RITUAL+TYPE_SPELL and re:IsHasType(EFFECT_TYPE_ACTIVATE) and bit.band(c:GetType(),0x81)==0x81 and aux.IsCodeListed(re:GetHandler(),c:GetCode())
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.cfilter,nil,re)
	for tc in aux.Next(g) do tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1) end
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:GetFlagEffect(m)>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(REASON_COST,tp,cm.filter,1,nil) end
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,cm.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
