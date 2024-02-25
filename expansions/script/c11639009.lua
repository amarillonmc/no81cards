local m=11639009
local cm=_G["c"..m]
cm.name="射弹上膛"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.srfilter(c)
	return c:IsSetCard(0xc221) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(11639009)
end
function cm.efilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc221)
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c) and c:GetEquipGroup():FilterCount(Card.IsSetCard,nil,0xc221)<=1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.eqfilter(c,tc)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xc221) and c:CheckEquipTarget(tc)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.efilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else op=Duel.SelectOption(tp,aux.Stringid(m,1))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.srfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,cm.efilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc)
		local eq=g:GetFirst()
		if eq then
			Duel.Equip(tp,eq,tc)
		end
	end
end