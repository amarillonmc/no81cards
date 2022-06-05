--混沌的双星
local m=10888909
local cm=_G["c"..m]

function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.TRUE,3,5,cm.lcheck)
	c:EnableReviveLimit()
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(cm.limcon)
	e1:SetTarget(cm.sumlimit)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.drcost)
	e4:SetTarget(cm.drtg)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
	--atkanddefdown
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCondition(cm.atkcon)
	e5:SetTarget(cm.atktg)
	e5:SetOperation(cm.atkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
end

function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x773)
end

function cm.limcon(e)
	return e:GetHandler():GetSequence()>4
end

function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLevelAbove(5) and c:IsLocation(LOCATION_HAND)
end

function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end

function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_SKIP_DP)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		end
		Duel.RegisterEffect(e1,tp)
	end
end

function cm.atkfilter(c,e,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP) and (not e or c:IsRelateToEffect(e))
end

function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.atkfilter,1,nil,nil,1-tp)
end

function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end

function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local predef=tc:GetDefense()
		if tc:IsPosition(POS_FACEUP_ATTACK) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-2000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		end
		if tc:IsPosition(POS_FACEUP_DEFENSE) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(-2000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if predef~=0 and tc:IsDefense(0) then dg:AddCard(tc) end
		end
		tc=g:GetNext()
	end
end