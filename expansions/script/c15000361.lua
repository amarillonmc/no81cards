local m=15000361
local cm=_G["c"..m]
cm.name="白辉一瞬"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000351)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)
	--to grave  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOGRAVE)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m) 
	e2:SetCost(aux.bfgcost)  
	e2:SetTarget(cm.tgtg)  
	e2:SetOperation(cm.tgop)  
	c:RegisterEffect(e2)
end
function cm.tgfilter(c)  
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_NORMAL) and c:IsAbleToGrave()  
end  
function cm.tgfilter1(c)  
	return aux.IsCodeListed(c,15000351) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) and tc:IsOriginalCodeRule(15000351) and Duel.IsExistingMatchingCard(cm.tgfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local g1=Duel.SelectMatchingCard(tp,cm.tgfilter1,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g1,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,g1) 
	end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)  
	return not c:IsRace(RACE_INSECT)
end
function cm.tggfilter(c)  
	return c:IsCode(15000351) and c:IsAbleToGrave()  
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tggfilter,tp,LOCATION_ONFIELD,0,1,nil) end  
	local g=Duel.GetMatchingGroup(cm.tggfilter,tp,LOCATION_ONFIELD,0,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)  
end  
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.tggfilter,tp,LOCATION_ONFIELD,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.HintSelection(g)  
		Duel.SendtoGrave(g,REASON_EFFECT)  
	end  
end