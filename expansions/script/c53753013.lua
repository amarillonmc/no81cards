local m=53753013
local cm=_G["c"..m]
cm.name="地构的异铜"
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
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.reccon)
	e3:SetOperation(cm.recop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.count1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(cm.count2)
		Duel.RegisterEffect(ge2,0)
	end
end
cm.has_text_type=TYPE_DUAL
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and SNNM.MultiDualCount(c)>0 and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp)) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local g=eg:Filter(cm.repfilter,nil,tp)
		Duel.SetTargetCard(g)
		return true
	else return false end
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:ForEach(SNNM.multi_summon_count_down)
end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and SNNM.MultiDualCount(c)>0
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and SNNM.MultiDualCount(tc)>0 and Duel.GetCurrentChain()>0
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	if SNNM.MultiDualCount(eg:GetFirst())~=Duel.GetFlagEffect(1-tp,m)-Duel.GetFlagEffect(1-tp,m+50) then return end
	for i=1,Duel.GetCurrentChain() do
		if Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)~=tp then Duel.NegateEffect(i) end
	end
end
function cm.count1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,m,RESET_CHAIN,0,1)
end
function cm.count2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,m+50,RESET_CHAIN,0,1)
end
