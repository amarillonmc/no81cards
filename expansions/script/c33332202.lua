--奉与授秽者之信仰
function c33332202.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,33332202)
	e1:SetTarget(c33332202.actg) 
	e1:SetOperation(c33332202.acop) 
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,13332202) 
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c33332202.ditg) 
	e2:SetOperation(c33332202.diop) 
	c:RegisterEffect(e2) 
end 
function c33332202.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(33332200) and c:IsAbleToGrave() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_MZONE) 
end 
function c33332202.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsCode(33332200) and c:IsAbleToGrave() end,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,99,nil) 
		local atk=sg:GetSum(Card.GetAttack)
		Duel.SendtoGrave(sg,REASON_EFFECT) 
		Duel.Recover(tp,atk,REASON_EFFECT) 
	end 
end 
function c33332202.ditg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
end 
function c33332202.diop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_DIRECT_ATTACK)  
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(function(e,c) 
	return c:IsCode(33332200) end) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp) 
end 

