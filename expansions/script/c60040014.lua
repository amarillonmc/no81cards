--太阳勇士·塞德斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--code
	aux.EnableChangeCode(c,60040004,LOCATION_MZONE+LOCATION_GRAVE)
	--synchro summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.drcon)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.drtarg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27548199,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000000)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND,0,1,nil) end
	local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND,0,nil)
	Duel.SendtoGrave(g2,REASON_COST)
	e:SetLabel(#g2)
	for i=1,#g2 do
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_REDIRECT,0,1)
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=e:GetLabel()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,num) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(num)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,num)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local lv=e:GetHandler():GetFlagEffect(m)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and lv~=0 and Duel.IsChainNegatable(ev) and rc:IsType(TYPE_MONSTER) and rc:IsLevelBelow(m)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end