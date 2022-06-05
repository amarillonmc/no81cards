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
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),7,3,cm.ovfilter,aux.Stringid(m,1),3,cm.xyzop)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.atkcon)
	e1:SetCost(cm.atkcost)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetCondition(cm.actcon)
	c:RegisterEffect(e4)
	
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsCode(40009966)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.actfilter(c,tp)
	return c:IsControler(tp)
end
function cm.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and (a and cm.actfilter(a,tp)) or (d and cm.actfilter(d,tp))
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.dsercon(e) and Duel.GetAttacker()==e:GetHandler()
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
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
function cm.atkfilter(c,lv)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and (c:IsLevel(lv) or c:IsRank(lv))
end
function cm.onefilter(c)
	return c:IsLevel(3) or c:IsRank(3)
end
function cm.twofilter(c)
	return c:IsLevel(4) or c:IsRank(4)
end
function cm.sevfilter(c)
	return c:IsLevel(7) or c:IsRank(7)
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
			local og=sg:Filter(cm.onefilter,nil)
			local tg=sg:Filter(cm.twofilter,nil)
			local seg=sg:Filter(cm.sevfilter,nil)
			local pg3=Duel.GetMatchingGroup(cm.onefilter,tp,LOCATION_MZONE,0,nil)
			local pg4=Duel.GetMatchingGroup(cm.twofilter,tp,LOCATION_MZONE,0,nil)
			local pg7=Duel.GetMatchingGroup(cm.sevfilter,tp,LOCATION_MZONE,0,nil)
			if og:GetCount()>0 then
				local tc1=pg3:GetFirst()
				while tc1 do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(800)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc1:RegisterEffect(e1)
					local e4=Effect.CreateEffect(c)
					e4:SetType(EFFECT_TYPE_SINGLE)
					e4:SetCode(EFFECT_EXTRA_ATTACK)
					e4:SetValue(1)
					e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
					tc1:RegisterEffect(e4)
					tc1=pg3:GetNext()
				end
			end
			if tg:GetCount()>0 then
				local tc2=pg4:GetFirst()
				while tc2 do
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_UPDATE_ATTACK)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetValue(800)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc2:RegisterEffect(e2)
					local e5=Effect.CreateEffect(c)
					e5:SetType(EFFECT_TYPE_SINGLE)
					e5:SetCode(EFFECT_EXTRA_ATTACK)
					e5:SetValue(1)
					e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
					tc2:RegisterEffect(e5)
					tc2=pg4:GetNext()
				end
			end
			if seg:GetCount()>0 then
				local tc3=pg7:GetFirst()
				while tc3 do
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_UPDATE_ATTACK)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetValue(800)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc3:RegisterEffect(e3)
					local e6=Effect.CreateEffect(c)
					e6:SetType(EFFECT_TYPE_SINGLE)
					e6:SetCode(EFFECT_EXTRA_ATTACK)
					e6:SetValue(1)
					e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
					tc3:RegisterEffect(e6)
					tc3=pg7:GetNext()
				end
			end
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
