--人理之诗 灼烧殆尽的炎笼
function c22020290.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,22020290)
	e1:SetCondition(c22020290.condition)
	e1:SetTarget(c22020290.target)
	e1:SetOperation(c22020290.activate)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,22020290) 
	e2:SetTarget(c22020290.ovtg)
	e2:SetOperation(c22020290.ovop)
	c:RegisterEffect(e2)
end
function c22020290.condition(e,tp,eg,ep,ev,re,r,rp)  
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc and rc:IsSummonLocation(LOCATION_EXTRA)
end
function c22020290.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsChainNegatable(ev)  
	local b2=re:GetHandler() and re:GetHandler():GetBaseAttack()>0 
	if chk==0 then return b1 or b2 end 
end
function c22020290.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local b1=Duel.IsChainNegatable(ev)  
	local b2=re:GetHandler() and re:GetHandler():GetBaseAttack()>0
	if b1 or b2 then 
		local xtable={} 
		if b1 then table.insert(xtable,aux.Stringid(22020290,1)) end 
		if b2 then table.insert(xtable,aux.Stringid(22020290,2)) end 
		if b1 and b2 and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(22020280) end,tp,LOCATION_MZONE,0,1,nil) then 
			table.insert(xtable,aux.Stringid(22020290,3))
		end 
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1  
		local xop=xtable[op] 
		if xop==aux.Stringid(22020290,1) or xop==aux.Stringid(22020290,3) then 
			Duel.NegateActivation(ev)
		end 
		if xop==aux.Stringid(22020290,2) or xop==aux.Stringid(22020290,3) then 
			if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(re:GetHandler(),REASON_EFFECT)~=0 then 
				Duel.Damage(1-tp,re:GetHandler():GetBaseAttack(),REASON_EFFECT) 
			end 
		end 
	end 
end
function c22020290.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6ff1) and c:IsType(TYPE_XYZ)
end
function c22020290.ovtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c22020290.ovfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22020290.ovfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function c22020290.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end






