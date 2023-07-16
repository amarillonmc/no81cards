local m=53763011
local cm=_G["c"..m]
cm.name="强狱场"
function cm.initial_effect(c)
	aux.AddCodeList(c,53763001)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.tcfilter(c)
	local lv=c:GetLevel()
	return c:IsFaceup() and lv~=0 and lv~=c:GetOriginalLevel()
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:FilterCount(cm.tcfilter,nil)==1
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=eg:GetFirst()
	local attr=rc:GetAttribute()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	local g4=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	local g5=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local b1=attr&ATTRIBUTE_DARK~=0 and #g1>0
	local b2=attr&ATTRIBUTE_EARTH~=0 and #g2>0
	local b3=attr&ATTRIBUTE_WATER~=0 and #g3>0
	local b4=attr&ATTRIBUTE_FIRE~=0 and #g4>0
	local b5=attr&ATTRIBUTE_WIND~=0 and #g5>0
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
	e:SetLabel(attr)
	Duel.SetTargetCard(rc)
	local ctg=CATEGORY_TOGRAVE
	if attr&ATTRIBUTE_DARK~=0 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	end
	if attr&ATTRIBUTE_EARTH~=0 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
	end
	if attr&ATTRIBUTE_WATER~=0 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g3,1,0,0)
	end
	if attr&ATTRIBUTE_FIRE~=0 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g4,1,0,0)
	end
	if attr&ATTRIBUTE_WIND~=0 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g5,1,0,0)
	end
	for i=Duel.GetCurrentChain(),1,-1 do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandler():IsCode(53763001) then Duel.SetChainLimit(cm.chainlm) end
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local attr=e:GetLabel()
	local res=0
	if attr&ATTRIBUTE_DARK~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			res=Duel.SendtoHand(g1,nil,REASON_EFFECT)
			if res>0 then res=g1:FilterCount(Card.IsLocation,nil,LOCATION_HAND) end
		end
	end
	if attr&ATTRIBUTE_EARTH~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		if #g2>0 then
			res=Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
			if res>0 then res=g2:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED) end
		end
	end
	if attr&ATTRIBUTE_WATER~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g3=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g3:GetCount()>0 then
			Duel.HintSelection(g3)
			res=Duel.Destroy(g3,REASON_EFFECT)
		end
	end
	if attr&ATTRIBUTE_FIRE~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g4=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
		if g4:GetCount()>0 then
			Duel.HintSelection(g4)
			res=Duel.Destroy(g4,REASON_EFFECT)
		end
	end
	if attr&ATTRIBUTE_WIND~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g5=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
		if g5:GetCount()>0 then
			Duel.HintSelection(g5)
			res=Duel.Destroy(g5,REASON_EFFECT)
		end
	end
	if res==0 then return end
	local rc=Duel.GetFirstTarget()
	if rc and rc:IsLocation(LOCATION_MZONE) and rc:IsRelateToChain() and not rc:IsLevel(rc:GetOriginalLevel()) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(rc:GetOriginalLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
	end
end
