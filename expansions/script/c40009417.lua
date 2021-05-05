--袭击队叛逆之翼
function c40009417.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),4,2)
	c:EnableReviveLimit()
	--rank up/down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009417,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40009417)
	e1:SetCost(c40009417.cost)
	e1:SetTarget(c40009417.target)
	e1:SetOperation(c40009417.operation)
	c:RegisterEffect(e1) 
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c40009417.xmatcon)
	e2:SetValue(1000)
	c:RegisterEffect(e2) 
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c40009417.xmatcon)
	e3:SetValue(c40009417.immval)
	c:RegisterEffect(e3) 
end
function c40009417.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009417.thfilter(c)
	return c:IsCode(88504133) and c:IsAbleToHand()
end
function c40009417.spfilter(c,e,tp)
	return  (c:IsSetCard(0x10db) or c:IsSetCard(0xba)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1)
end
function c40009417.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsExistingMatchingCard(c40009417.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40009417.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c40009417.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   -- local sg=Duel.GetMatchingGroup(c40009417.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	--local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	--local tc=g:GetFirst()
	local tg=Duel.GetFirstMatchingCard(c40009417.thfilter,tp,LOCATION_DECK,0,nil)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c40009417.cfilter,nil)
   -- local tc=Duel.GetOperatedGroup():GetFirst()
	if tg then
	   -- if tc:IsType(TYPE_MONSTER) and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40009417,2)) then
		   -- Duel.SendtoHand(tg,nil,REASON_EFFECT)
		  --  Duel.ConfirmCards(1-tp,tg) 
		  --  Duel.BreakEffect()
		  --  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  --  local pg=sg:Select(tp,1,1,nil)
		  --  Duel.SpecialSummon(pg,0,tp,tp,false,false,POS_FACEUP)
		--end
   -- else
	 --   Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	   -- Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	   -- if tg then
	   -- if not tc:IsType(TYPE_MONSTER) then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,tg) 
	   end
	   -- end
	   if ct==0 then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c40009417.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(40009417,2)) then
		   Duel.BreakEffect()
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40009417.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	--end
end
function c40009417.xmatcon(e)
	return e:GetHandler():GetOriginalAttribute()==ATTRIBUTE_DARK
end
function c40009417.immval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
		and te:GetOwner():GetAttack()<=e:GetHandler():GetAttack() and te:IsActivated()
end
