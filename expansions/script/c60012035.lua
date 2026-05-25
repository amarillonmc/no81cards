-- 优雅的虫风花
--Duel.LoadScript("c.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetOperation(cm.op0)
	c:RegisterEffect(e0)
	
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_NEGATED)
		ge1:SetOperation(cm.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_CHAIN_NEGATED)
		ge3:SetOperation(cm.checkop2)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge2:Clone()
		ge4:SetCode(EVENT_CHAIN_NEGATED)
		ge4:SetOperation(cm.checkop3)
		Duel.RegisterEffect(ge4,0)
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFieldID()<=172 then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.handcon(e)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.checkop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local de=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON)
	if de and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.checkop3(e,tp,eg,ep,ev,re,r,rp)
	local de=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON)
	if de and not re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetFlagEffect(1,m+re:GetHandler():GetCode())==0 then
		Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,m+re:GetHandler():GetCode(),RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=Duel.GetFlagEffect(1,m)
	if chk==0 then return num~=0 and Duel.IsPlayerCanDraw(tp,num) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(num)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,num)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end


