function c82221045.initial_effect(c)  
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DRAW+CATEGORY_DAMAGE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c82221045.target)  
	e1:SetOperation(c82221045.activate)  
	c:RegisterEffect(e1)  
end  
function c82221045.filter(c)  
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToExtra()
end  
function c82221045.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)  
		and Duel.IsExistingMatchingCard(c82221045.filter,tp,LOCATION_HAND,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_HAND)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)  
end  
function c82221045.activate(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)  
	local g=Duel.SelectMatchingCard(tp,c82221045.filter,tp,LOCATION_HAND,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc and Duel.SendtoExtraP(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_EXTRA) then  
		if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.Damage(tp,1000,REASON_EFFECT)
		end
	end  
end  