local m=53799250
local cm=_G["c"..m]
cm.name="断绝"
if not require and Duel.LoadScript then
    function require(str)
        local name=str
        for word in string.gmatch(str,"%w+") do
            name=word
        end
        Duel.LoadScript(name..".lua")
        return true
    end
end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.CardnameBreak(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(function(e)return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)<=1 end)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetOperation(cm.reset1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_SOLVING)
		ge3:SetOperation(cm.count2)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_CHAIN_SOLVED)
		ge4:SetOperation(cm.reset1)
		Duel.RegisterEffect(ge4,0)
	end
end
function cm.reset1(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.IsPlayerAffectedByEffect(ep,EFFECT_CANNOT_SPECIAL_SUMMON) and cm.sp) or (Duel.IsPlayerAffectedByEffect(ep,EFFECT_CANNOT_ACTIVATE) and cm.ac) then Duel.RegisterFlagEffect(ep,m,RESET_PHASE+PHASE_END,0,1) end
	cm.sp=false
	cm.ac=false
end
function cm.count2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(ep,EFFECT_CANNOT_SPECIAL_SUMMON) then cm.sp=true end
	if not Duel.IsPlayerAffectedByEffect(ep,EFFECT_CANNOT_ACTIVATE) then cm.ac=true end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainDisablable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.GetFlagEffect(1-tp,m)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() and Duel.NegateEffect(ev) and tc:IsRelateToEffect(re) then Duel.Destroy(eg,REASON_EFFECT) end
end
