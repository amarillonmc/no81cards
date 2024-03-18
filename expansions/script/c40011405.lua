--极大卫星兵器
function c40011405.initial_effect(c)
	c:SetUniqueOnField(1,0,40011405) 
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_COUNTER+CATEGORY_DAMAGE) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c40011405.actg) 
	e1:SetOperation(c40011405.acop) 
	c:RegisterEffect(e1) 
end
function c40011405.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200) 
	if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xf11) and c:IsLevelAbove(7) end,tp,LOCATION_MZONE,0,1,nil) then 
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1) 
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0xf11)
	end  
end 
function c40011405.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xf11) and c:IsLevelAbove(7) end,tp,LOCATION_MZONE,0,1,nil) then 
		Duel.Draw(tp,1,REASON_EFFECT) 
		if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(40011407) and c:IsCanAddCounter(0xf11,3) end,tp,LOCATION_SZONE,0,1,nil) then 
			local cc=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsCode(40011407) and c:IsCanAddCounter(0xf11,3) end,tp,LOCATION_SZONE,0,1,1,nil):GetFirst() 
			cc:AddCounter(0xf11,3)
		end 
	end  
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst() 
	if tc then 
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end 
	Duel.Damage(1-tp,1200,REASON_EFFECT) 
end 


