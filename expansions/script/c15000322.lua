local m=15000322
local cm=_G["c"..m]
cm.name="内核感染 许德拉"
function cm.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)   
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,15000322)  
	e1:SetCondition(cm.spcon)  
	e1:SetCost(cm.spcost)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)
	--remove overlay replace  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15010322)  
	e2:SetCondition(cm.rcon)  
	e2:SetOperation(cm.rop)  
	c:RegisterEffect(e2)
end
function cm.filter(c)  
	return c:IsAbleToHand() and c:IsSetCard(0xf39) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function cm.costfilter(c)  
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xf39) and c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	return Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_DECK,0,nil)~=0
end  
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())  
	Duel.SendtoGrave(g,REASON_COST)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local tp=e:GetHandler():GetControler()  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end 
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)  
	return c:GetRace()~=RACE_FIEND  
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and re:GetHandler():GetOverlayCount()>=ev-1 and e:GetHandler():IsAbleToGraveAsCost() and ep==e:GetOwnerPlayer() and re:GetHandler():IsSetCard(0xf39)
end  
function cm.rop(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.SendtoGrave(e:GetHandler(),REASON_COST)  
end