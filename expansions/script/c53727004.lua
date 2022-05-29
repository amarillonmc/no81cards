local m=53727004
local cm=_G["c"..m]
cm.name="空间撕裂"
cm.cybern_numc=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.AddCodeList(c,53727003)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return re:IsHasType(EFFECT_TYPE_ACTIVATE)end)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(cm.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.valcheck(e,c)
	if c:GetMaterial():IsExists(Card.IsType,3,nil,TYPE_MONSTER) then c:RegisterFlagEffect(m,RESET_EVENT+0x4fe0000,0,1) end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,53727003):GetClassCount(Card.GetOriginalCodeRule)
	local b1=ct>Duel.GetFlagEffect(0,m) and re:GetHandler():IsDestructable()
	local b2=ct>Duel.GetFlagEffect(0,m+33)+2 and Duel.IsChainDisablable(ev)
	local b3=ct>Duel.GetFlagEffect(0,m+66)+5
	if chk==0 then return b1 or b2 or b3 end
	SNNM.CyberNSwitch(e:GetHandler())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	SNNM.CyberNSwitch(e:GetHandler())
	local c,tc=e:GetHandler(),re:GetHandler()
	local ct=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,53727003):GetClassCount(Card.GetOriginalCodeRule)
	local b1=ct>Duel.GetFlagEffect(0,m) and re:GetHandler():IsRelateToEffect(re)
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,3))
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.RegisterFlagEffect(0,m,0,0,0)
	end
	local b2=ct>Duel.GetFlagEffect(0,m+33)+2 and Duel.IsChainDisablable(ev)
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,4))
		Duel.NegateEffect(ev)
		Duel.RegisterFlagEffect(0,m+33,0,0,0)
	end
	local b3=ct>Duel.GetFlagEffect(0,m+66)+4
	if b3 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,5))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(cm.distg1)
		e1:SetLabelObject(tc)
		if Duel.GetTurnPlayer()~=tp then e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2) else e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1) end
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon)
		e2:SetOperation(cm.disop)
		e2:SetLabelObject(tc)
		if Duel.GetTurnPlayer()~=tp then e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2) else e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1) end
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(function(e,c)return c:IsOriginalCodeRule(e:GetLabelObject():GetOriginalCodeRule())end)
		e3:SetLabelObject(tc)
		if Duel.GetTurnPlayer()~=tp then e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2) else e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1) end
		Duel.RegisterEffect(e3,tp)
		Duel.RegisterFlagEffect(0,m+66,0,0,0)
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.IsExistingMatchingCard(function(c)return c:GetFlagEffect(m)~=0 and c:IsCode(53727002) and c:GetSummonType()&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION and c:IsFaceup()end,tp,LOCATION_MZONE,0,1,nil) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function cm.distg1(e,c)
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then return c:IsOriginalCodeRule(e:GetLabelObject():GetOriginalCodeRule()) else return c:IsOriginalCodeRule(e:GetLabelObject():GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOriginalCodeRule(e:GetLabelObject():GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end