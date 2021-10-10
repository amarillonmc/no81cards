--最强兽神 穷奇·极
local m=40009968
local cm=_G["c"..m]
cm.named_with_BeastDeity=1
function cm.BeastDeity(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BeastDeity
end

function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(cm.BeastDeity),7,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.atkcon)
	e1:SetCost(cm.atkcost)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2)
	
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() and e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) or Duel.GetAttackTarget()==e:GetHandler()
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(m)==0 end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return false end
		local g=Duel.GetDecktopGroup(tp,2)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and cm.BeastDeity(c)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return false end
		local g=Duel.GetDecktopGroup(tp,2)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetTargetPlayer(tp)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,2)
	local g=Duel.GetDecktopGroup(p,2)
	if g:GetCount()>0 then
		local sg=g:Filter(cm.filter,nil)
		if sg:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.Overlay(c,sg)
			Duel.RaiseEvent(sg,EVENT_CUSTOM+40009964,e,REASON_REVEAL,0,tp,0)
			g:Sub(sg)
			--atkup
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			e1:SetValue(sg:GetCount()*800)
			c:RegisterEffect(e1)
		end
		local sg2=g:Filter(Card.IsAbleToHand,nil)
		if sg2:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg2)
			Duel.ShuffleHand(p)
		end
	end
end
