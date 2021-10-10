--刻神编年史-时刻人偶
local m=40009580
local cm=_G["c"..m]

function cm.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.discon)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1) 
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1,m+1)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)  
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_NEGATE) and Duel.IsChainNegatable(ev)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	e:SetLabel(100)
	if chk==0 then return c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.cfilter(c)
	return c:IsSetCard(0x4f1d) and c:IsType(TYPE_MONSTER) and not c:IsPublic() 
end
function cm.gfilter(g,e,tp,c)
	return g:IsContains(c) and Duel.IsExistingMatchingCard(cm.scfilter,tp,LOCATION_EXTRA,0,1,nil,tp,g)
end
function cm.scfilter(c,tp,mg)
	return c:IsSynchroSummonable(nil,mg,#mg-1,#mg-1) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return e:GetLabel()==100 and g:IsContains(c) and g:CheckSubGroup(cm.gfilter,1,4,e,tp,c) and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_SYNCHRO_MATERIAL,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:SelectSubGroup(tp,cm.gfilter,false,1,4,e,tp,c)
	Duel.ConfirmCards(1-tp,cg)
	Duel.SetTargetCard(cg)
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)	
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #g~=g:FilterCount(Card.IsRelateToEffect,nil,e) then return end
	if Duel.SpecialSummon(c,SUMMON_VALUE_SYNCHRO_MATERIAL,tp,tp,false,false,POS_FACEUP)<=0 then return end
	local sg=Duel.GetMatchingGroup(cm.scfilter,tp,LOCATION_EXTRA,0,nil,tp,g)
	if #sg>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.SynchroSummon(tp,sc,nil,g,#g-1,#g-1)
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	e:SetLabel(0)
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,e:GetHandler())
		g:AddCard(e:GetHandler())
		e:SetLabel(1) 
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	end
end
function cm.thfilter(c)
	return c:IsSetCard(0x4f1d) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if #g<=0 then return end
	local ct=1
	if e:GetLabel()==1 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
end