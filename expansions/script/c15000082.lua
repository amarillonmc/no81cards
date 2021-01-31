local m=15000082
local cm=_G["c"..m]
cm.name="廷达魔三角之追猎者"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,nil,4,2)  
	c:EnableReviveLimit()
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,m)  
	e1:SetCost(cm.spcost)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1) 
	--negate  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)  
	e2:SetCondition(cm.negcon)  
	e2:SetTarget(cm.negtg)  
	e2:SetOperation(cm.negop)  
	c:RegisterEffect(e2)   
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tp=e:GetHandlerPlayer()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x10b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tp=e:GetHandlerPlayer()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandlerPlayer()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)  
		if g:GetCount()>0 then  
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,g)  
		end  
	end  
end
function cm.negfilter(c)  
	return c:IsFacedown() and c:IsCanChangePosition()
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x10b)  
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return aux.nbcon(tp,re) end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)  
	end  
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)  
	end  
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(cm.negfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local g=Duel.SelectMatchingCard(tp,cm.negfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()~=0 then
			local tc=g:GetFirst()
			local pos1=0  
			if not tc:IsPosition(POS_FACEUP_ATTACK) then pos1=pos1+POS_FACEUP_ATTACK end  
			if not tc:IsPosition(POS_FACEUP_DEFENSE) then pos1=pos1+POS_FACEUP_DEFENSE end  
			local pos2=Duel.SelectPosition(tp,tc,pos1)  
			Duel.ChangePosition(tc,pos2)
		end
	end
end