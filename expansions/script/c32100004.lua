--核心硬币 鹰雀鹫联组
function c32100004.initial_effect(c)
	aux.AddCodeList(c,32100002)
	--spsummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCost(c32100004.spcost)
	e1:SetTarget(c32100004.sptg)
	e1:SetOperation(c32100004.spop)
	c:RegisterEffect(e1) 
	--atk
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(32100004,1)) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1)  
	e1:SetTarget(c32100004.atktg)
	e1:SetOperation(c32100004.atkop)
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
	e1:SetValue(1000)  
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
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)  
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
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32100004,3))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET) 
	e1:SetCountLimit(1)  
	e1:SetTarget(c32100004.negtg)
	e1:SetOperation(c32100004.negop)
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
c32100004.SetCard_HR_Corecoin=true 
function c32100004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToGraveAsCost() and c.SetCard_HR_Corecoin and c:IsType(TYPE_MONSTER) end,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToGraveAsCost() and c.SetCard_HR_Corecoin and c:IsType(TYPE_MONSTER) end,tp,LOCATION_HAND,0,2,2,e:GetHandler()) 
	g:AddCard(e:GetHandler()) 
	Duel.SendtoGrave(g,REASON_COST) 
end 
function c32100004.spfilter(c,e,tp)
	return c:IsCode(32100002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32100004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32100004.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c32100004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32100004.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c32100004.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c32100004.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(-500)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		tc=g:GetNext() 
		end 
	end
end
function c32100004.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c32100004.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.NegateAttack() 
end


