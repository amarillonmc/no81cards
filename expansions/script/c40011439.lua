--光辉元素 坡坡瓦
function c40011439.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetCountLimit(1,40011439)  
	e1:SetCost(c40011439.setcost)
	e1:SetTarget(c40011439.settg)
	e1:SetOperation(c40011439.setop)
	c:RegisterEffect(e1)	
	--counter 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10011439)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c40011439.cttg)
	e2:SetOperation(c40011439.ctop)
	c:RegisterEffect(e2)
end
function c40011439.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c40011439.setfilter(c)
	return c:IsCode(40011407) and c:IsSSetable()
end
function c40011439.settg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsExistingMatchingCard(c40011439.setfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(40011407) and c:IsCanAddCounter(0xf11,3) end,tp,LOCATION_SZONE,0,1,nil)
	if chk==0 then return b1 or b2 end 
	if b2 then 
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0xf11) 
	end 
end
function c40011439.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c40011439.setfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(40011407) and c:IsCanAddCounter(0xf11,3) end,tp,LOCATION_SZONE,0,1,nil)
	if b2 then 
		local tc=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsCode(40011407) and c:IsCanAddCounter(0xf11,3) end,tp,LOCATION_SZONE,0,1,1,nil):GetFirst()
		tc:AddCounter(0xf11,3) 
	elseif b1 then 
		local tc=Duel.SelectMatchingCard(tp,c40011439.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()  
		if tc then 
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end 
			Duel.SSet(tp,tc) 
		end
	end 
end
function c40011439.ctfil(c)
	return c:IsFaceup() and c:IsCode(40011407) and c:IsCanAddCounter(0x33,3)
end
function c40011439.cttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c40011439.ctfil,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40011439,0))
	Duel.SelectTarget(tp,c40011439.ctfil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0xf11)
end
function c40011439.ctop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0xf11,3) 
	end
end



