--异晶界骑士
local m=40020136
local cm=_G["c"..m]
function cm.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)	
	--Special Summon a Token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(cm.tkcon)
	e3:SetTarget(cm.tktg)
	e3:SetOperation(cm.tkop)
	c:RegisterEffect(e3)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
	return c:IsRace(RACE_FISH) and c:IsLevel(3,4,5) and c:IsAbleToHand()		and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.tgfilter(c,lv)
	return c:IsRace(RACE_FISH) and c:IsLevel(3,4,5) and c:IsAbleToGrave()
		and not c:IsLevel(lv)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)>0 and g1:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g1)
		local g2=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil,g1:GetFirst():GetLevel())
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
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
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function cm.tkcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x48) and c:IsType(TYPE_XYZ)
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.tkcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tkfilter(c)
	return c:IsSetCard(0x73) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tkfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tkfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
