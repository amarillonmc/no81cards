--邪魂 御使邪物的使徒 赛薇
function c30000615.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),7,3)
	c:EnableReviveLimit()
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c30000615.limit)
	c:RegisterEffect(e0)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30000615,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(c30000615.tgcost)
	e1:SetCondition(c30000615.tgcon)
	e1:SetTarget(c30000615.tgtg)
	e1:SetOperation(c30000615.tgop)
	c:RegisterEffect(e1) 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30000615,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c30000615.tdcost)
	e2:SetCondition(c30000615.tdcon)
	e2:SetTarget(c30000615.tdtg)
	e2:SetOperation(c30000615.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c30000615.tdcon1)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(30000615,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c30000615.thcon)
	e4:SetTarget(c30000615.thtg)
	e4:SetOperation(c30000615.thop)
	c:RegisterEffect(e4)  
end
function c30000615.limit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not se
end
function c30000615.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c30000615.tgfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return g:GetClassCount(Card.GetCode)>2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c30000615.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c30000615.tgfilter(c)
	return c:IsDefense(0) and c:IsAbleToGraveAsCost() and c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c30000615.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,30000615)==0 end
end
function c30000615.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetValue(c30000615.effectfilter)  
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterFlagEffect(tp,30000615,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetValue(c30000615.effectfilter)  
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_CANNOT_DISABLE)  
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetValue(c30000615.effectfilter)  
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c30000615.effectfilter(e,ct)  
	local p=e:GetHandler():GetControler()  
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)  
	return p==tp and te:GetHandler():IsAttribute(ATTRIBUTE_DARK) and te:GetHandler():IsDefense(0) and te:GetHandler():IsType(TYPE_MONSTER)
end 
function c30000615.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,30000010)
end 
function c30000615.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,30000010)
end 
function c30000615.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c30000615.thfilter(c)
	return c:IsAbleToGrave()
end
function c30000615.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000615.thfilter,tp,LOCATION_REMOVED,0,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,5,tp,LOCATION_REMOVED)
end
function c30000615.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local gg=Duel.GetMatchingGroup(c30000615.thfilter,tp,LOCATION_REMOVED,0,nil)
	local g=gg:RandomSelect(tp,5)
	if g:GetCount()==5 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
	local og=Duel.GetOperatedGroup()
	og=og:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if og:GetCount()>0 then 
		for tc in aux.Next(og) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function c30000615.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c30000615.thfilter2(c,e,tp)
	return c:IsSetCard(0x5d5) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30000615.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,5,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,tp,LOCATION_REMOVED)
end
function c30000615.thfilter1(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER) and c:IsDefense(0)
end
function c30000615.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsAbleToExtra() then return end
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c30000615.thfilter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
		if tg:GetCount()>0 then
			if Duel.SendtoHand(tg,tp,REASON_EFFECT)~=0 then
				Duel.ConfirmCards(1-tp,tg)
				local gg=Duel.GetMatchingGroup(c30000615.thfilter,tp,LOCATION_REMOVED,0,nil)
				local g=gg:RandomSelect(tp,5)
				if g:GetCount()==5 then
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
				end
			end
		end
	end
end