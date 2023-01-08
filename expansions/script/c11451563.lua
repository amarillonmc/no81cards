--诡雷战术 潜伏诱捕
--21.04.22
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--trap
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCost(cm.trcost)
	e3:SetTarget(cm.trtg)
	e3:SetOperation(cm.trop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(cm.con)
	e5:SetTarget(cm.trtg2)
	c:RegisterEffect(e5)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	local tc=re:GetHandler()
	return tc:IsControler(1-tp) and loc&LOCATION_MZONE~=0
end
function cm.trcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and (c:IsFaceup() or Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)) and c:GetEquipTarget() end
	if c:IsFacedown() then Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD) end
	e:SetLabelObject(c:GetEquipTarget())
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.filter(c,tp)
	return c:IsFaceup() and c:IsSummonPlayer(1-tp) and c:IsCanTurnSet()
end
function cm.trtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.filter,1,nil,tp) and not eg:IsContains(e:GetHandler():GetEquipTarget()) end
	local g=eg:Filter(cm.filter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,#g,0,0)
end
function cm.trtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=re:GetHandler()
	if chk==0 then return tc:IsRelateToEffect(re) and tc:IsFaceup() and tc:IsCanTurnSet() and tc:IsControler(1-tp) and tc~=e:GetHandler():GetEquipTarget() end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.trop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=e:GetLabelObject()
	local g=Group.CreateGroup()
	if e:GetCode()==EVENT_CHAINING then
		g=Group.FromCards(re:GetHandler()):Filter(Card.IsRelateToEffect,nil,re)
	else
		g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	end
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 and rc:IsLocation(LOCATION_MZONE) and rc:IsFaceup() then
		local og=Duel.GetOperatedGroup():Filter(Card.IsFacedown,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ft<=0 then return elseif ft>#og then ft=#og end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		for i=1,ft do
			local tc=og:Select(tp,1,1,nil):GetFirst()
			og:RemoveCard(tc)
			if Duel.Equip(tp,tc,rc,false,true) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetLabelObject(rc)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
		Duel.EquipComplete()
	end
end