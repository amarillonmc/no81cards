--黑衣之战栗 加百列
local m=40009892
local cm=_G["c"..m]
cm.named_with_Relief=1
function cm.initial_effect(c)
	--recover 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.rdcon)
	e1:SetTarget(cm.rdtg)
	e1:SetOperation(cm.rdop)
	c:RegisterEffect(e1)  
	cm.discard_effect=e1
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.adcon)
	e2:SetTarget(cm.adtg)
	e2:SetOperation(cm.adop)
	c:RegisterEffect(e2)  
end
function cm.rdcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<8000
end
function cm.rdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local rec=math.abs(8000-Duel.GetLP(tp))
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,rec)
end
function cm.rdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local rec=math.abs(8000-Duel.GetLP(tp))
	local dam=Duel.Recover(tp,rec,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Damage(tp,dam,REASON_EFFECT)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=1000
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=math.floor(ev/1000)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=math.floor(ev/1000)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,dg)
	local g=Duel.GetDecktopGroup(tp,dg)
	if g:GetCount()>0 then 
		local ct=g:Filter(Card.IsType,nil,TYPE_MONSTER)
		if ct:GetFirst():IsAbleToGrave() then
			local atk=Duel.SendtoGrave(ct,REASON_EFFECT+REASON_REVEAL)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk*2000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
	Duel.ShuffleDeck(tp)
end











