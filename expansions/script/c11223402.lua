local m=11223402
local cm=_G["c"..m]
cm.name="血粒子"
function cm.initial_effect(c)
	--Direct Attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--To Hand/Grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.batop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Double Attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_DISABLED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.condition)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
end
--To Hand/Grave
function cm.batop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabel((bc and 0 or 1))
end
function cm.thfilter(c)
	return c:GetAttack()==500 and c:GetDefense()==500 and c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsRace(RACE_WARRIOR) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject():GetLabel()
	if chk==0 then return bc and bc==1
		and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:IsAbleToGrave()
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
--Double Attack
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==eg:GetFirst() and e:GetHandler():IsFaceup()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.atkop)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(e:GetHandler():GetAttack()*2)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	e:GetHandler():RegisterEffect(e1)
end