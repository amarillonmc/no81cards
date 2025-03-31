--超时空战斗机世界 幻想乡
local m=13257336
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_FZONE)
	e0:SetOperation(cm.im)
	c:RegisterEffect(e0)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetCountLimit(1,TAMA_THEME_CODE+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(cm.recon)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(cm.ctop1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(cm.ctop2)
	c:RegisterEffect(e5)
	elements={{"theme_effect",e2}}
	cm[c]=elements
	
end
function cm.im(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc then return end
	local BMe=tama.getTargetTable(rc,"bomb")
	if BMe and re==BMe then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		rc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(cm.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		e:GetHandler():RegisterEffect(e2)
		if rc:GetEquipTarget() then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetValue(cm.efilter)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			rc:GetEquipTarget():RegisterEffect(e3)
		end
	end
end
function cm.efilter(e,te)
	return e:GetHandler()~=te:GetOwner() and e:GetOwner()~=te:GetOwner() and not te:GetOwner():IsType(TYPE_EQUIP)
end
function cm.canActivate(c,PCe,eg,ep,ev,re,r,rp)
	local tep=c:GetControler()
	local cost=PCe:GetCost()
	local target=PCe:GetTarget()
	return (not cost or cost(PCe,tep,eg,ep,ev,re,r,rp,0))
		and (not target or target(PCe,tep,eg,ep,ev,re,r,rp,0))
end
function cm.recon(e,tp)
	return not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,1-tp,m)
	Duel.ConfirmCards(1-tp,c)
	Duel.Remove(c,POS_FACEDOWN,REASON_RULE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(TAMA_THEME_CODE)
	e1:SetTargetRange(1,0)
	e1:SetValue(m)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(cm.ctop1a)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(cm.ctop2a)
	Duel.RegisterEffect(e4,tp)
end
function cm.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if ep==tp and tc:IsCanAddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1) then
		tc:AddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1)
	end
end
function cm.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsSummonPlayer(tp) and tc:IsCanAddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1) then
			tc:AddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1)
		end
		tc=eg:GetNext()
	end
end
function cm.ctop1a(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if ep==tp and tc:IsSetCard(0x351) and tc:IsCanAddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1) then
		tc:AddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1)
	end
end
function cm.ctop2a(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsSummonPlayer(tp) and tc:IsSetCard(0x351) and tc:IsCanAddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1) then
			tc:AddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1)
		end
		tc=eg:GetNext()
	end
end
