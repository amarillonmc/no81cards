--革命武装
local cm,m=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,99518961)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--act limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(cm.actlimit)
	c:RegisterEffect(e5)
	--codelist
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(m)
	c:RegisterEffect(e7)
	if not cm.global_check then
		cm.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(cm.adjust)
		Duel.RegisterEffect(ge0,0)
	end
end
function cm.adjust(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(0,LOCATION_MZONE,LOCATION_MZONE)
	g=g:Filter(function(c) return c:IsHasEffect(m) and (not c.card_code_list or not c.card_code_list[99518961]) end,nil)
	for c in aux.Next(g) do
		cm[c:GetOriginalCode()]=true
		if c.card_code_list==nil then
			local mt=getmetatable(c)
			mt.card_code_list={}
			mt.card_code_list[99518961]=true
		else
			c.card_code_list[99518961]=true
		end
	end
	g=Duel.GetFieldGroup(0,LOCATION_MZONE,LOCATION_MZONE)
	sg=Duel.GetFieldGroup(0,0xff,0xff)+Duel.GetOverlayGroup(0,1,1)
	sg=sg:Filter(function(c) return cm[c:GetOriginalCode()] and not g:IsExists(function(sc) return sc:IsHasEffect(m) and sc:GetOriginalCode()==c:GetOriginalCode() end,1,nil) end,nil)
	for c in aux.Next(sg) do
		cm[c:GetOriginalCode()]=nil
		local mt=getmetatable(c)
		if mt.card_code_list and #mt.card_code_list>1 then
			mt.card_code_list[99518961]=nil
		else
			mt.card_code_list=nil
		end
	end
end
function cm.eqlimit(e,c)
	return aux.IsCodeListed(c,99518961) and c:IsType(TYPE_MONSTER)
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) --and aux.IsCodeListed(c,99518961)
end
function cm.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function cm.filter3(c)
	return c:IsCode(99518961) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function cm.atkval(e,c)
	local g=Duel.GetMatchingGroup(cm.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)*1000
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ctfilter,1,nil)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipTarget() and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(0,1) and Duel.IsPlayerCanDraw(1,1) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<=5 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
end
function cm.actlimit(e,re,tp)
	return e:GetHandler():GetEquipTarget()~=nil and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)>=6 and re:GetHandler():IsLocation(LOCATION_HAND)
end