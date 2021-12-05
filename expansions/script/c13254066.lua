--飞球的延续
local m=13254066
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.smtg)
	e1:SetOperation(cm.smop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	elements={{"tama_elements",{{TAMA_ELEMENT_MANA,1},{TAMA_ELEMENT_LIFE,1}}}}
	cm[c]=elements
	
end
function cm.fselect(g,tp)
	return g:IsExists(cm.tdfilter,1,nil) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tama.tamas_sumElements(g))
end
function cm.tdfilter(c)
	return #tama.tamas_getElements(c)>0 and c:IsAbleToDeck()
end
function cm.thfilter(c,el)
	return c:IsAbleToHand() and c:IsSetCard(0x3356) and tamas_isAllElementsNotAbove(tama.tamas_getElements(c),el)
end
function cm.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(cm.fselect,1,g:GetCount(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cm.smop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroupCount(cm.tdfilter,tp,LOCATION_GRAVE,0)
	--[[
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,g:GetCount(),nil)
	if sg:GetCount()>0 then
	]]
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,1,g:GetCount(),tp)
	if sg and sg:GetCount()>0 then
		local el=tama.tamas_sumElements(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		local g1=Duel.GetMatchingGroupCount(cm.thfilter,tp,LOCATION_DECK,0,el)
		if g1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg1=g1:Select(tp,1,g1:GetCount(),nil)
			local tc=sg1:GetFirst()
			if Duel.SendtoHand(sg1,tp,REASON_EFFECT)>0 and tc:IsSummonable(true,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
				Duel.BreakEffect()
				Duel.Summon(tp,tc,true,nil)
			end
		end
	end
end
function cm.fselect1(g,tp)
	return g:GetClassCount(Card.GetCode)==1 and g:GetCount()>=2 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,g:GetFirst():GetCode())
end
function cm.thfilter1(c,code)
	return c:IsCode(tc:GetCode()) and c:IsAbleToHand()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,0x5356)
	if chk==0 then return g:CheckSubGroup(cm.fselect1,2,g:GetCount(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,0x5356)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
	local sg=g:SelectSubGroup(tp,cm.fselect1,false,2,2,tp)
	if sg and sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,sg:GetFirst():GetCode())
		local tc=sg1:GetFirst()
		if tc and Duel.SendtoHand(tc,tp,REASON_EFFECT)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(math.ceil(tc:GetBaseAttack()/2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(math.ceil(tc:GetBaseDefense()/2))
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end
