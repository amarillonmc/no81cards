--魔合成-怨毒之握击
local m=40011475
local cm=_G["c"..m]
cm.named_with_MagicCombineMagic=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
function cm.cfilter1(c)
	return c:GetType()==TYPE_SPELL and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(false,true,false)~=nil  
end
function cm.cfilter2(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(false,true,false)~=nil  
end
function cm.cfilterz(c)
	return c:IsFaceup() and cm.Spiritualist(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g1=Duel.GetMatchingGroup(cm.cfilter1,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(cm.cfilter2,tp,LOCATION_GRAVE,0,nil)
	if Duel.IsPlayerAffectedByEffect(tp,40011471) then
		g1:Merge(g2)
	end
	if g1:GetCount()>0 and Duel.IsExistingMatchingCard(cm.cfilterz,tp,LOCATION_MZONE,0,1,nil) then 
		if Duel.IsPlayerAffectedByEffect(tp,40011471) then 
			Duel.SelectYesNo(tp,aux.Stringid(m,2)) 
		else 
			Duel.SelectYesNo(tp,aux.Stringid(m,1))
		end 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g1:Select(tp,1,1,nil):GetFirst() 
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
		local te,ceg,cep,cev,cre,cr,crp=sg:CheckActivateEffect(false,true,true)
		e:SetProperty(te:GetProperty())  
		local tg=te:GetTarget()  
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end  
		te:SetLabelObject(e:GetLabelObject())  
		e:SetLabelObject(te)  
		Duel.ClearOperationInfo(0)  
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.filter(c)
	return c:IsCode(40011471) and c:IsAbleToHand()
end
function cm.thfilter(c,e,tp)
	return c:IsLevel(6) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_ZOMBIE) and c:IsAttack(2000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.IsEnvironment(40011471,tp,LOCATION_FZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) or (b and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.IsEnvironment(40011471,tp,LOCATION_FZONE)
	if b and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)) and (not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end