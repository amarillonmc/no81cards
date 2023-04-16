local m=53727010
local cm=_G["c"..m]
cm.name="死锁剑"
function cm.initial_effect(c)
	aux.AddCodeList(c,53727003)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(cm.eqlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(cm.value)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():GetEquipTarget() and e:GetHandler():GetEquipTarget():IsCode(53727002)end)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetValue(aux.indoval)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_LEAVE_GRAVE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_CUSTOM+m)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCondition(cm.setcon)
	e8:SetTarget(cm.settg)
	e8:SetOperation(cm.setop)
	c:RegisterEffect(e8)
	aux.RegisterMergedDelayedEvent(c,m,EVENT_SSET)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function cm.eqlimit(e,c)
	return c:IsRace(RACE_CYBERSE) and c:GetControler()==e:GetHandler():GetControler()
end
function cm.value(e,c)
	return Duel.GetMatchingGroup(Card.IsCode,e:GetHandler():GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,53727003):GetClassCount(Card.GetOriginalCodeRule)*500
end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and aux.exccon(e)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable(true) end
	Duel.SetTargetCard(eg:Filter(cm.cfilter,nil,tp))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg:Filter(cm.cfilter,nil,tp),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.cfilter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	local rg=g:Clone()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	if #rg>1 then rg=g:Select(tp,1,1,nil) end
	Duel.HintSelection(rg)
	if Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)~=0 and rg:GetFirst():IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
	end
end
