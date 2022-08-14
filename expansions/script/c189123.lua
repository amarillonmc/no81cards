--煌煌世界坠入深渊
function c189123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--add 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)	
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1) 
	e2:SetTarget(c189123.adtg) 
	e2:SetOperation(c189123.adop) 
	c:RegisterEffect(e2) 
	--des 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,189123)
	e3:SetCondition(c189123.discon)
	e3:SetCost(c189123.discost)
	e3:SetTarget(c189123.distg)
	e3:SetOperation(c189123.disop)
	c:RegisterEffect(e3)
end
function c189123.adfil(c) 
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_FIRE) 
end 
function c189123.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c189123.adfil,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SelectTarget(tp,c189123.adfil,tp,LOCATION_MZONE,0,1,1,nil)
end 
function c189123.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then 
	-- 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_ADD_ATTRIBUTE) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(ATTRIBUTE_FIRE) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1) 
	end 
end 
function c189123.discon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)~=0 and re:GetHandler()~=e:GetHandler() 
end 
function c189123.ctfil(c) 
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsReleasable() 
end  
function c189123.ctgck(g,tp) 
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,g:GetCount(),g)	  
end 
function c189123.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(c189123.ctfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:CheckSubGroup(c189123.ctgck,1,2,tp) end
	local sg=g:SelectSubGroup(tp,c189123.ctgck,false,1,2,tp)
	local x=Duel.Release(sg,REASON_COST) 
	e:SetLabel(x) 
end
function c189123.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local x=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,x,0,LOCATION_ONFIELD)
end
function c189123.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	if g:GetCount()>x then 
	local dg=g:Select(tp,x,x,nil) 
		local tc=dg:GetFirst()   
		while tc do 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET) 
		Duel.Destroy(tc,REASON_EFFECT) 
		tc=dg:GetNext() 
		end 
	end 
end











