local m=15000240
local cm=_G["c"..m]
cm.name="旧世界：永寂之国"
function cm.initial_effect(c)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--stats up  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf37))  
	e2:SetValue(cm.atkval)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e3)
	--indes  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e4:SetRange(LOCATION_FZONE)  
	e4:SetTargetRange(LOCATION_MZONE,0)  
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf37))  
	e4:SetValue(1)  
	c:RegisterEffect(e4)
	--tohand  
	local e5=Effect.CreateEffect(c)  
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,m)  
	e5:SetCost(cm.thcost)  
	e5:SetTarget(cm.thtg)  
	e5:SetOperation(cm.thop)  
	c:RegisterEffect(e5)
end
function cm.atkval(e,c)  
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()*100
	else
		if not c:IsType(TYPE_LINK) then
			return c:GetLevel()*100
		end
	end
	return 0
end
function cm.thfilter(c)
	return c:IsSetCard(0xaf37) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xf37) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tp=e:GetHandler():GetControler()
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)  
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g) 
		Duel.BreakEffect()
		if (g:GetFirst():IsCode(15000241) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)  
			if fc then  
				Duel.SendtoGrave(fc,REASON_RULE)  
				Duel.BreakEffect()  
			end  
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,1-tp,g:GetFirst():GetCode())
			local te=g:GetFirst():GetActivateEffect()  
			te:UseCountLimit(tp,1,true)
			local tep=g:GetFirst():GetControler()  
			local cost=te:GetCost()  
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end  
			Duel.RaiseEvent(g:GetFirst(),4179255,te,0,tp,tp,Duel.GetCurrentChain())
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local ag=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if ag:GetFirst() then
				Duel.SpecialSummon(ag:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end  
end