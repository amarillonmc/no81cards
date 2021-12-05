local m=53799088
local cm=_G["c"..m]
cm.name="魔轰神界之压"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(cm.con)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return (c:GetSummonLocation()==LOCATION_GRAVE or c:GetSummonLocation()==LOCATION_HAND) and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
end
function cm.thfilter(c,pg)
	return c:IsSetCard(0x35) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not pg:IsExists(cm.thfilter2,1,nil,c)
end
function cm.thfilter2(c,g)
   return c:GetCode()==g:GetCode()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,3,nil)
	if #g>0 then 
		Duel.HintSelection(g)
		local ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
		local pg=Duel.GetOperatedGroup()
		local hg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,pg)
		if ct>0 and #hg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=hg:SelectSubGroup(tp,aux.dncheck,false,1,ct)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,e:GetHandler())<=1
end
function cm.thfilter3(c)
	return c:IsSetCard(0x35) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter3),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
