--超时空武装 副武-穿甲导弹
local m=13257321
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(cm.eqlimit)
	c:RegisterEffect(e11)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(cm.descost)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	--[[
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.damcon)
	e4:SetTarget(cm.damtg)
	e4:SetOperation(cm.damop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BATTLE_DESTROYED)
	e5:SetCondition(cm.damcon1)
	c:RegisterEffect(e5)
	]]
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(cm.negcon)
	e6:SetCost(cm.descost)
	e6:SetTarget(cm.negtg)
	e6:SetOperation(cm.negop)
	c:RegisterEffect(e6)
	
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x6352)
end
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local f=tama.cosmicFighters_equipGetFormation(c)
	if chk==0 then return f and c:GetFlagEffect(m)<f:GetCount() end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		if dg:GetCount()>0 then
			Duel.HintSelection(dg)
			local tc=dg:GetFirst()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
			Duel.AdjustInstantly()
			if Duel.Destroy(dg,REASON_EFFECT)>0 then
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD)
				e4:SetCode(EFFECT_DISABLE)
				e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				e4:SetTarget(cm.distg)
				e4:SetLabelObject(tc)
				e4:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e4,tp)
				local e5=Effect.CreateEffect(c)
				e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e5:SetCode(EVENT_CHAIN_SOLVING)
				e5:SetCondition(cm.discon)
				e5:SetOperation(cm.disop)
				e5:SetLabelObject(tc)
				e5:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e5,tp)
			end
		end
	end
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return tc and c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local tc=e:GetLabelObject()
	return rc:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
end
function cm.cfilter1(c,tp)
	return c:GetPreviousControler()==tp and c:IsReason(REASON_BATTLE)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(cm.cfilter,1,nil,1-tp) then return false end
	local rc=re:GetHandler()
	local c=e:GetHandler()
	local f=tama.cosmicFighters_equipGetFormation(c)
	return c:GetEquipTarget() and (rc==c or (f and f:IsContains(rc)))
end
function cm.damcon1(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(cm.cfilter1,1,nil,1-tp) then return false end
	local rc=eg:GetFirst():GetReasonCard()
	local c=e:GetHandler()
	local f=tama.cosmicFighters_equipGetFormation(c)
	return c:GetEquipTarget() and (rc==c or (f and f:IsContains(rc)))
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_GRAVE and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and Duel.IsChainNegatable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsOnField() and tc:IsRelateToEffect(te) then
				dg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and Duel.NegateActivation(i) then
			local tc=te:GetHandler()
			if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then
				dg:AddCard(tc)
			end
		end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
