--耀雷风暴
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000150)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(cm.nilcost)
	e2:SetOperation(cm.nilactivate)
	c:RegisterEffect(e2)
	
	--Atk up
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_EQUIP)
	e22:SetCode(EFFECT_UPDATE_ATTACK)
	e22:SetValue(800)
	c:RegisterEffect(e22)
	local e3=e22:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)

	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.eqtg)
	e4:SetOperation(cm.eqop)
	--c:RegisterEffect(e4)

	local e44=Effect.CreateEffect(c)
	e44:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e44:SetRange(LOCATION_SZONE)
	e44:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e44:SetTarget(cm.eftg)
	e44:SetLabelObject(e4)
	c:RegisterEffect(e44)
end
function cm.confil(c)
	return c:IsCode(60000150) and c:IsFaceup()
end
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m,RESET_CHAIN,0,1)
end
function cm.nilcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)~=0 end
	Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m,RESET_CHAIN,0,1)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	e:GetHandler():CreateEffectRelation(e)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.confil(chkc) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsExistingTarget(cm.confil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.confil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:CancelToGrave()
	if not c:IsLocation(LOCATION_SZONE) then return end
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Equip(tp,c,tc) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(cm.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	else
		c:CancelToGrave(false)
	end
end
function cm.nilactivate(e,tp,eg,ep,ev,re,r,rp)
end
function cm.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() or e:GetHandler():GetEquipTarget()==c
end
function cm.eqfil1(c)
	return c:IsFaceup() and not (c:IsAttack(0) and c:IsDefense(0))
end
function cm.eqfil2(c)
	return aux.IsCodeListed(c,60000150) and c:IsAbleToDeck()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.eqfil1,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(cm.eqfil2,tp,LOCATION_GRAVE,0,num,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if not Duel.IsExistingMatchingCard(cm.eqfil2,tp,LOCATION_GRAVE,0,num,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.eqfil2,tp,LOCATION_GRAVE,0,num,num,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		for tc in aux.Next(mg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e2)
		end
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ATTACK_ALL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e3)
	end
end
function cm.eftg(e,c)
	return c:GetEquipGroup():IsContains(e:GetHandler())
end