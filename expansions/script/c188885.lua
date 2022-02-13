local m=188885
local cm=_G["c"..m]
cm.name="星魅真龙-逆乌德里斯"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,function(c)return c:IsLevel(1) and c:IsRace(RACE_DRAGON)end,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(function(e,c)return c:IsSetCard(0xca2) and c:IsRace(RACE_WYRM)end)
	e1:SetValue(700)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1,m+100)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.discon)
	e4:SetTarget(cm.distg)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainDisablable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0) end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 and Duel.GetFlagEffect(tp,m)==0 then
		Duel.BreakEffect()
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return rp~=tp end)
		e1:SetOperation(cm.mvop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(g:GetFirst(),nseq)
	e:Reset()
end
