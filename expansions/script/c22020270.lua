--人理之诗 穿刺死棘之枪
function c22020270.initial_effect(c) 
	aux.AddCodeList(c,22021220)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)  
	e1:SetCondition(c22020270.accon)
	e1:SetTarget(c22020270.actg)
	e1:SetOperation(c22020270.acop)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,22020270) 
	e2:SetTarget(c22020270.ovtg)
	e2:SetOperation(c22020270.ovop)
	c:RegisterEffect(e2)
end
function c22020270.accon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:IsControler(tp)
end
function c22020270.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
	local at=Duel.GetAttacker()
	local b2=at and at:GetBaseAttack()>0 
	if chk==0 then return b1 or b2 end 
end
function c22020270.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(tp,aux.Stringid(22020270,0))
	local c=e:GetHandler() 
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
	local at=Duel.GetAttacker()
	local b2=at and at:GetBaseAttack()>0 
	if Duel.NegateAttack() and (b1 or b2) then 
		local xtable={} 
		if b1 then table.insert(xtable,aux.Stringid(22020270,1)) end 
		if b2 then table.insert(xtable,aux.Stringid(22020270,2)) end 
		if b1 and b2 and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(22020260,22021220) end,tp,LOCATION_MZONE,0,1,nil) then 
			table.insert(xtable,aux.Stringid(22020270,3))
		end 
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1  
		local xop=xtable[op] 
		if xop==aux.Stringid(22020270,1) or xop==aux.Stringid(22020270,3) then 
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil) 
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end 
		if xop==aux.Stringid(22020270,2) or xop==aux.Stringid(22020270,3) then 
			Duel.Damage(1-tp,at:GetBaseAttack(),REASON_EFFECT) 
		end 
	end 
end 
function c22020270.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6ff1) and c:IsType(TYPE_XYZ)
end
function c22020270.ovtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c22020270.ovfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22020270.ovfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function c22020270.ovop(e,tp,eg,ep,ev,re,r,rp)
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






