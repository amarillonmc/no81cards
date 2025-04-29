--背反之料理餐厅 『Crépuscule』
local m=7438108
local cm=_G["c"..m]

cm.named_with_Crooked_Cook=1

function cm.Crooked_Cook(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_Crooked_Cook or c:IsCode(82697249))
end
function cm.Crooked_Cook_Antipasto(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Antipasto
end
function cm.Crooked_Cook_Soup(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Soup
end
function cm.Crooked_Cook_Enree(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Enree
end
function cm.Crooked_Cook_Main_Course(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Main_Course
end
function cm.Crooked_Cook_Salad(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Salad
end
function cm.Crooked_Cook_Dessert(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Dessert
end
function cm.Crooked_Cook_Drink(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Drink
end

function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.reccon)
	e3:SetTarget(cm.rectg)
	e3:SetOperation(cm.recop)
	c:RegisterEffect(e3)
end
function cm.cfilter(c)
	return c:IsReason(REASON_EFFECT) and cm.Crooked_Cook(c)
end
function cm.filter(c)
	return c:IsType(TYPE_QUICKPLAY) and cm.Crooked_Cook(c)
end
function cm.thfilter(c,dc)
	local f=false
	if cm.Crooked_Cook_Antipasto(dc) then f=cm.Crooked_Cook_Soup(c) end
	if cm.Crooked_Cook_Soup(dc) then f=cm.Crooked_Cook_Enree(c) end
	if cm.Crooked_Cook_Enree(dc) then f=cm.Crooked_Cook_Main_Course(c) end
	if cm.Crooked_Cook_Main_Course(dc) then f=cm.Crooked_Cook_Salad(c) end
	if cm.Crooked_Cook_Salad(dc) then f=cm.Crooked_Cook_Dessert(c) end
	if cm.Crooked_Cook_Dessert(dc) then f=cm.Crooked_Cook_Drink(c) end
	return cm.Crooked_Cook(c) and c:IsAbleToHand() and (f or cm.Crooked_Cook_Antipasto(c))
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local dc=Duel.GetOperatedGroup():GetFirst()
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,dc)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,300)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,300,REASON_EFFECT)
	Duel.Recover(1-tp,300,REASON_EFFECT)
	--attackdown
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(-300)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
