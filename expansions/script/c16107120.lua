--至点堺王 代号：海王星
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16107120,"GODONOVALORDKINGOFRING")
local nova=0x1cc ----nova counter
function cm.initial_effect(c)
	--xyz summon
	c:EnableCounterPermit(nova)
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,nil,3,99)
	c:EnableReviveLimit()
	--XYZ SUM
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_1:SetRange(LOCATION_MZONE)
	e1_1:SetValue(1)
	c:RegisterEffect(e1_1)
	--copy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.copycon1)
	e2:SetTarget(cm.copytg)
	e2:SetOperation(cm.copyop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	--QuickBuff
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.copycon2)
	c:RegisterEffect(e4)
end
function cm.splimit(e,se,sp,st)
	return st&SUMMON_TYPE_XYZ~=0
end
function cm.mfilter(c,xyzc)
	return c:IsRankAbove(12) and c:IsRace(RACE_SEASERPENT)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.copycon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,16107112)==0
end
function cm.copycon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,16107112)~=0 and e:GetHandler():IsOriginalSetCard(0xccc)
end
function cm.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsAttackAbove(0) or c:IsDefenseAbove(0))
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local cg=c:GetOverlayGroup()
	if chk==0 then return cg:IsExists(cm.copyfilter,1,nil) end
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetOverlayGroup()
	local num=Duel.GetTurnCount()
	local sg=cg:Filter(cm.copyfilter,nil)
	local atk=0
	local def=0
	if sg:GetCount()>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		for tc in aux.Next(sg) do
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
			atk=atk+tc:GetAttack()
			def=def+tc:GetDefense()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
		c:AddCounter(nova,sg:GetCount())
	end
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackAbove(0) end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()   
	local atk=c:GetAttack()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsAttackAbove(0) then
		local lp=Duel.GetLP(1-tp)
		if lp<=atk then
			Duel.SetLP(1-tp,0)
		else
			Duel.PayLPCost(1-tp,atk)
		end
	end
end
