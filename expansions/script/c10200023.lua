--焚炎天器 御裂日轮
function c10200023.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c10200023.mfilter,c10200023.xyzcheck,6,6)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10200023.con2)
	e2:SetOperation(c10200023.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10200023,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(c10200023.con3)
	e3:SetTarget(c10200023.tg3)
	e3:SetOperation(c10200023.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c10200023.atkval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10200023,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c10200023.cost5)
	e5:SetTarget(c10200023.tg5)
	e5:SetOperation(c10200023.op5)
	c:RegisterEffect(e5)
	--[[local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10200023,2))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c10200023.tg6)
	e6:SetOperation(c10200023.op6)
	c:RegisterEffect(e6)]]
end
function c10200023.mfilter(c,xyzc)
	return c:IsType(TYPE_XYZ)
end
function c10200023.xyzcheck(g)
	return g:GetClassCount(Card.GetOriginalRank)==#g
end
function c10200023.getlimit(tp)
	local sum=0
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_XYZ)
	for tc in aux.Next(g) do
		local og=tc:GetOverlayGroup()
		for oc in aux.Next(og) do
			local rnk=oc:GetOriginalRank()
			if rnk>0 then sum=sum+rnk end
		end
	end
	return sum
end
function c10200023.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c10200023.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:CheckRemoveOverlayCard(tp,1,REASON_COST) then
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		Duel.Destroy(c,REASON_COST)
	end
end
function c10200023.con3(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10200023.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10200023)<c10200023.getlimit(tp) end
	Duel.RegisterFlagEffect(tp,10200023,RESET_PHASE+PHASE_END,0,1)
	local limit=c10200023.getlimit(tp)
	local flag=Duel.GetFlagEffect(tp,10200023)
	Debug.Message("=== 御裂日轮 调试信息 ===")
	Debug.Message("效果可使用次数: "..tostring(limit))
	Debug.Message("已使用次数: "..tostring(flag))
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c10200023.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and c:IsType(TYPE_XYZ) then
		rc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(rc))
	end
end
function c10200023.atkval(e,c)
	local g=c:GetOverlayGroup()
	local sum=0
	local tc=g:GetFirst()
	while tc do
		local lvl=tc:GetOriginalLevel()
		if lvl>0 then sum=sum+lvl end
		local rnk=tc:GetOriginalRank()
		if rnk>0 then sum=sum+rnk end
		tc=g:GetNext()
	end
	return sum*100
end
function c10200023.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10200023.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,10200023)<c10200023.getlimit(tp) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.RegisterFlagEffect(tp,10200023,RESET_PHASE+PHASE_END,0,1)
	local limit=c10200023.getlimit(tp)
	local flag=Duel.GetFlagEffect(tp,10200023)
	Debug.Message("=== 御裂日轮 调试信息 ===")
	Debug.Message("效果可使用次数: "..tostring(limit))
	Debug.Message("已使用次数: "..tostring(flag))
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetChainLimit(c10200023.chlimit)
end
function c10200023.chlimit(e,ep,tp)
	return ep==tp or not e:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c10200023.op5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
end
--[[function c10200023.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10200023)<c10200023.getlimit(tp) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.RegisterFlagEffect(tp,10200023,RESET_PHASE+PHASE_END,0,1)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10200023.op6(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end]]
