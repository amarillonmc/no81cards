--时穿剑·魄斩剑
local m=14000019
local cm=_G["c"..m]
cm.named_with_Chronoblade=1
xpcall(function() require("expansions/script/c14000001") end,function() require("script/c14000001") end)
function cm.initial_effect(c)
	--chrbeffects
	chrb.dire(c)
	--win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(cm.wincon)
	e4:SetOperation(cm.winop)
	c:RegisterEffect(e4)
end
function cm.wincon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.winop1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.winop1(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_CHRONO_BLADE=0x24
	Duel.Win(tp,WIN_REASON_CHRONO_BLADE)
end