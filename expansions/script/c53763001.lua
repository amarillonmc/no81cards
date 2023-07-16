local m=53763001
local cm=_G["c"..m]
cm.name="无穷牢"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonEffect():IsActiveType(TYPE_MONSTER))
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if c:IsReason(REASON_EFFECT) then rc=c:GetReasonEffect():GetHandler() end
	local attr=(rc:IsPreviousLocation(LOCATION_MZONE) and rc:GetPreviousAttributeOnField()) or rc:GetAttribute()
	e:SetLabel(attr)
	Duel.SetTargetCard(rc)
	local ctg=CATEGORY_TOGRAVE
	if attr&ATTRIBUTE_DARK~=0 then
		ctg=ctg|CATEGORY_REMOVE
		local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
	end
	if attr&ATTRIBUTE_EARTH~=0 then
		ctg=ctg|CATEGORY_DESTROY
		local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
	end
	if attr&ATTRIBUTE_WATER~=0 then
		ctg=ctg|CATEGORY_DESTROY
		local g3=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g3,1,0,0)
	end
	if attr&ATTRIBUTE_FIRE~=0 then
		ctg=ctg|CATEGORY_DESTROY
		local g4=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g4,1,0,0)
	end
	if attr&ATTRIBUTE_WIND~=0 then
		ctg=ctg|CATEGORY_TOHAND
		local g5=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g5,1,0,0)
	end
	e:SetCategory(ctg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToGrave()
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetFirstTarget()
	if rc and rc:IsLocation(LOCATION_MZONE) and rc:IsRelateToChain() and not rc:IsLevel(rc:GetOriginalLevel()) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(rc:GetOriginalLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
	end
	local attr=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,attr)
	if #g==0 or Duel.SendtoGrave(g,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_GRAVE) then return end
	if attr&ATTRIBUTE_DARK~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		if #g1>0 then Duel.Remove(g1,POS_FACEUP,REASON_EFFECT) end
	end
	if attr&ATTRIBUTE_EARTH~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g2:GetCount()>0 then
			Duel.HintSelection(g2)
			Duel.Destroy(g2,REASON_EFFECT)
		end
	end
	if attr&ATTRIBUTE_WATER~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g3=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
		if g3:GetCount()>0 then
			Duel.HintSelection(g3)
			Duel.Destroy(g3,REASON_EFFECT)
		end
	end
	if attr&ATTRIBUTE_FIRE~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g4=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
		if g4:GetCount()>0 then
			Duel.HintSelection(g4)
			Duel.Destroy(g4,REASON_EFFECT)
		end
	end
	if attr&ATTRIBUTE_WIND~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g5=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
		if g5:GetCount()>0 then
			Duel.HintSelection(g5)
			Duel.SendtoHand(g5,nil,REASON_EFFECT)
		end
	end
end
