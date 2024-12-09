--星芒构解
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
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
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
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetTarget(cm.eftg4)
	e3:SetValue(1)
	c:RegisterEffect(e3)

	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,3))
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,m+10000000)
	e6:SetCondition(cm.eqcon5)
	e6:SetTarget(cm.eqtg5)
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
	return c:IsType(TYPE_TRAP) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tp=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.costfil,tp,LOCATION_SZONE,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local g=Duel.GetMatchingGroup(cm.costfil,tp,LOCATION_SZONE,0,e:GetHandler())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local cg=g:Select(tp,1,#g,nil)
		Duel.SendtoGrave(cg,REASON_COST)
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
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)*300
end
function cm.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	end
end
function cm.eftg2(e,c)
	return c:GetEquipGroup():IsContains(e:GetHandler()) and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>=2
end
function cm.eqop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60000156)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function cm.eftg3(e,c)
	return c:GetEquipGroup():IsContains(e:GetHandler()) and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>=3
end
function cm.eftg4(e,c)
	local tc=c:GetEquipTarget()
	return tc and tc:GetEquipGroup():IsContains(c) and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>=4
end
function cm.eqfil5(c)
	return (c:IsType(TYPE_EQUIP) or (c:GetType()==TYPE_TRAP and aux.IsCodeListed(c,60000150)))
end
function cm.eqcon5(e,tp,eg,ep,ev,re,r,rp)
	return #e:GetHandler():GetEquipGroup()<3
end
function cm.eqtg5(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=3-#e:GetHandler():GetEquipGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.eqfil5,tp,LOCATION_DECK+LOCATION_GRAVE,0,num,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>=num end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.eqop5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=3-#e:GetHandler():GetEquipGroup()
	if Duel.IsExistingMatchingCard(cm.eqfil5,tp,LOCATION_DECK+LOCATION_GRAVE,0,num,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>=num then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eg=Duel.SelectMatchingCard(tp,cm.eqfil5,tp,LOCATION_DECK+LOCATION_GRAVE,0,num,num,nil)
		for ec in aux.Next(eg) do
			if Duel.Equip(tp,ec,c,true) then
				local e1=Effect.CreateEffect(ec)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetLabelObject(c)
				e1:SetValue(cm.teqlimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				ec:RegisterEffect(e1)
			end
		end
		Duel.EquipComplete()
	end
end
function cm.eftg5(e,c)
	return c:GetEquipGroup():IsContains(e:GetHandler()) and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>=5
end
function cm.teqlimit(e,c)
	return e:GetLabelObject()==c
end