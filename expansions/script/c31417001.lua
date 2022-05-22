local m=31417001
local cm=_G["c"..m]
cm.name="圣域歌姬-小葱"
if not pcall(function() require("expansions/script/c31417000") end) then require("expansions/script/c31417000") end
function cm.initial_effect(c)
	Seine_Vocaloid.enable(c,1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.damcon)
	e1:SetTarget(cm.damtg)
	e1:SetOperation(cm.damop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e3)
end
function cm.target(e,c)
	return c:IsLevelAbove(10)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	local rc=des:GetReasonCard()
	return des:IsType(TYPE_MONSTER) and rc:IsRelateToBattle() and rc:IsLevelAbove(10)
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local damp=eg:GetFirst():GetPreviousControler()
	Duel.SetTargetPlayer(damp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,damp,1000)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,v=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,v,REASON_EFFECT)
end