local m=82228606
local cm=_G["c"..m]
cm.name="荒兽 蛊"
function cm.initial_effect(c)
	--handes  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,1))  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_XMATERIAL)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)  
	e1:SetCost(cm.cost)  
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.hdtg)  
	e1:SetOperation(cm.hdop)  
	c:RegisterEffect(e1)
	--destroy  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m)  
	e2:SetCost(cm.descost)  
	e2:SetTarget(cm.destg)  
	e2:SetOperation(cm.desop)  
	c:RegisterEffect(e2) 
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSetCard(0x2299)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end 
function cm.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)  
end  
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)  
	if g:GetCount()==0 then return end  
	local sg=g:RandomSelect(1-tp,1)  
	Duel.HintSelection(sg)
	Duel.SendtoGrave(sg,REASON_EFFECT)  
end  
function cm.cfilter(c)  
	return c:IsSetCard(0x2299) and c:IsDiscardable()  
end  
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end  
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD)  
end  
function cm.filter(c)  
	return c:IsType(TYPE_SPELL+TYPE_TRAP)  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and cm.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end  