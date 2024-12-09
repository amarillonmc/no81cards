--超速律频
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
	--Atk up
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_EQUIP)
	e22:SetCode(EFFECT_UPDATE_ATTACK)
	e22:SetValue(cm.val)
	c:RegisterEffect(e22)
	local e3=e22:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.eqcost2)
	e4:SetTarget(cm.eqtg2)
	e4:SetOperation(cm.eqop2)
	local e44=Effect.CreateEffect(c)
	e44:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e44:SetRange(LOCATION_SZONE)
	e44:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e44:SetTarget(cm.eftg2)
	e44:SetLabelObject(e4)
	c:RegisterEffect(e44)

	--be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_BECOME_TARGET)
	e5:SetOperation(cm.eqop3)
	local e55=Effect.CreateEffect(c)
	e55:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e55:SetRange(LOCATION_SZONE)
	e55:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e55:SetTarget(cm.eftg3)
	e55:SetLabelObject(e5)
	c:RegisterEffect(e55)
	--pierce
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_PIERCE)
	e7:SetValue(DOUBLE_DAMAGE)
	local e77=Effect.CreateEffect(c)
	e77:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e77:SetRange(LOCATION_SZONE)
	e77:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e77:SetTarget(cm.eftg4)
	e77:SetLabelObject(e7)
	c:RegisterEffect(e77)

	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,3))
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,m+10000000)
	e6:SetOperation(cm.eqop5)
	local e66=Effect.CreateEffect(c)
	e66:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e66:SetRange(LOCATION_SZONE)
	e66:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e66:SetTarget(cm.eftg5)
	e66:SetLabelObject(e6)
	c:RegisterEffect(e66)
end
function cm.confil(c)
	return c:IsCode(60000150) and c:IsFaceup()
end
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function cm.costfil(c)
	return aux.IsCodeListed(c,60000150) and c:IsAbleToDeckAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tp=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.costfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local g=Duel.GetMatchingGroup(cm.costfil,tp,LOCATION_GRAVE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local cg=g:Select(tp,1,#g,nil)
		Duel.SendtoDeck(cg,nil,2,REASON_COST)
		local num=#Duel.GetOperatedGroup()
		if num==0 then return end
		for i=1,num do
			Duel.RegisterFlagEffect(tp,m,0,0,1)
		end
	end
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
function cm.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() or e:GetHandler():GetEquipTarget()==c
end
function cm.val(e,c)
	if Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>=3 then
		return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)*100
	else return 0 end
end
function cm.eqcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local num=math.floor(Duel.GetLP(e:GetHandlerPlayer())/2)
	Duel.PayLPCost(e:GetHandlerPlayer(),num)
	e:SetLabel(num)
end
function cm.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function cm.eqop2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then return end
	local lp=e:GetLabel()
	local num=0
	while lp>=800 do
		num=num+1
		lp=lp-800
	end
	local dg=Duel.GetDecktopGroup(tp,num)
	Duel.ConfirmDecktop(tp,num)
	Duel.SendtoHand(dg:Filter(cm.egfil2,nil),nil,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(hg,nil,1,REASON_EFFECT)
end
function cm.egfil2(c)
	return (aux.IsCodeListed(c,60000150) or c:IsType(TYPE_EQUIP)) and c:IsAbleToHand()
end
function cm.eftg2(e,c)
	return c:GetEquipGroup():IsContains(e:GetHandler()) and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>=6
end
function cm.eqop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60000160)
	Duel.Recover(tp,800,REASON_EFFECT)
end
function cm.eftg3(e,c)
	return c:GetEquipGroup():IsContains(e:GetHandler()) and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>=9
end
function cm.eftg4(e,c)
	return c:GetEquipGroup():IsContains(e:GetHandler()) and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>=12
end


function cm.eqop5(e,tp,eg,ep,ev,re,r,rp)
	--negate
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(cm.negop)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp) 
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:GetControler()~=tp and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.NegateEffect(ev)
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		e:Reset()
	end
end
function cm.eftg5(e,c)
	return c:GetEquipGroup():IsContains(e:GetHandler()) and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>=15
end




