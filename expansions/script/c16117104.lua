--星皇 必胜
local m=16117104
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,cm.fusfilter1,cm.fusfilter2,cm.fusfilter3,cm.fusfilter4,cm.fusfilter5,cm.fusfilter6) 
--mzone limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_MAX_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(cm.value)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MAX_SZONE)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetTarget(cm.damtg)
	e4:SetOperation(cm.damop)
	c:RegisterEffect(e4)
end
function cm.fusfilter1(c)
	return c:IsFusionType(TYPE_FUSION)
end
function cm.fusfilter2(c)
	return c:IsFusionType(TYPE_SYNCHRO)
end
function cm.fusfilter3(c)
	return c:IsFusionType(TYPE_XYZ)
end
function cm.fusfilter4(c)
	return c:IsFusionType(TYPE_PENDULUM)
end
function cm.fusfilter5(c)
	return c:IsFusionType(TYPE_RITUAL)
end
function cm.fusfilter6(c)
	return c:IsFusionType(TYPE_LINK)
end
function cm.value(e,fp,rp,r)
	local sp=1-e:GetHandlerPlayer()
	if rp==e:GetHandlerPlayer() or r~=LOCATION_REASON_TOFIELD then return 7 end
	local limit=Duel.GetFieldGroupCount(sp,LOCATION_ONFIELD,0)
	if 4-limit>0 then
		return limit+1
	else
		return 0
	end
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetBattleTarget()
	local atk=tc:GetBaseAttack()
	if atk<0 then atk=0 end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	Duel.ChainAttack()
end