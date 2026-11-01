local m=15006341
local cm=_G["c"..m]
cm.name="折折界的月落兔"
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	--tog
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e4:SetCountLimit(1,m+1)
	e4:SetCost(cm.tgcost)
	e4:SetCondition(cm.tgcon1)
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
end
function cm.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,e:GetHandler(),tp) and e:GetHandler():IsFacedown() and not eg:IsContains(e:GetHandler())
end
function cm.spcon4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,e:GetHandler(),tp) and e:GetHandler():IsFacedown() and not eg:IsContains(e:GetHandler())
end
function cm.thfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x5f45) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			local sg=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,1,nil)
			if #sg>0 then
				Duel.BreakEffect()
				Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end
function cm.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,c)
end
function cm.cfilter(c,tp)
	return c:IsFacedown() and c:IsControler(tp)
end
function cm.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,e:GetHandler(),tp) and not eg:IsContains(e:GetHandler())
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local x=1
	if e:GetHandler():IsPosition(POS_FACEDOWN) then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
		x=2
	end
	e:SetLabel(x)
end
function cm.tgfilter(c,res)
	return ((c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanTurnSet()) or (c:IsAbleToGrave() and res==2))
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()
	if e:GetHandler():IsFacedown() then res=2 end
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_ONFIELD,nil,res)
	if chk==0 then return #g>0 end
	if res==2 then
		e:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local res=e:GetLabel()
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_ONFIELD,nil,res)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil,res):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		if res==2 and tc:IsAbleToGrave()
			and (not (tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc:IsCanTurnSet()) or Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))==1) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
	end
end