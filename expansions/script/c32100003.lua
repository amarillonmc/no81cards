--核心硬币 鹰雀鹫联组
function c32100003.initial_effect(c)
	aux.AddCodeList(c,32100002)
	--spsummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCost(c32100003.spcost)
	e1:SetTarget(c32100003.sptg)
	e1:SetOperation(c32100003.spop)
	c:RegisterEffect(e1) 
	--check 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(32100003,1)) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1)  
	e1:SetTarget(c32100003.cktg)
	e1:SetOperation(c32100003.ckop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetLabelObject(e1) 
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c==e:GetHandler():GetEquipTarget() end) 
	e2:SetCondition(function(e) 
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsCode(32100002) and e:GetHandler():GetSequence()==1 end)
	c:RegisterEffect(e2)
	--atk  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(500)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetLabelObject(e1) 
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c==e:GetHandler():GetEquipTarget() end) 
	e2:SetCondition(function(e) 
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsCode(32100002) and e:GetHandler():GetSequence()==2 end)
	c:RegisterEffect(e2) 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(1)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetLabelObject(e1) 
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c==e:GetHandler():GetEquipTarget() end) 
	e2:SetCondition(function(e) 
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsCode(32100002) and e:GetHandler():GetSequence()==2 end)
	c:RegisterEffect(e2) 
	--direct 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32100003,3)) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1)  
	e1:SetTarget(c32100003.dirtg)
	e1:SetOperation(c32100003.dirop) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetLabelObject(e1) 
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c==e:GetHandler():GetEquipTarget() end) 
	e2:SetCondition(function(e) 
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsCode(32100002) and e:GetHandler():GetSequence()==3 end)
	c:RegisterEffect(e2)
end
c32100003.SetCard_HR_Corecoin=true 
function c32100003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToGraveAsCost() and c.SetCard_HR_Corecoin and c:IsType(TYPE_MONSTER) end,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToGraveAsCost() and c.SetCard_HR_Corecoin and c:IsType(TYPE_MONSTER) end,tp,LOCATION_HAND,0,2,2,e:GetHandler()) 
	g:AddCard(e:GetHandler()) 
	Duel.SendtoGrave(g,REASON_COST) 
end 
function c32100003.spfilter(c,e,tp)
	return c:IsCode(32100002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32100003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32100003.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c32100003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32100003.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c32100003.cktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c32100003.ckop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
	end
end
function c32100003.dirtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c32100003.dirop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(-500) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_DIRECT_ATTACK) 
		e1:SetRange(LOCATION_MZONE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		c:RegisterEffect(e1)
	end 
end 


