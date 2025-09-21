--拨弄时光的指针
function c67201550.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c67201550.target)
	e1:SetOperation(c67201550.activate)
	c:RegisterEffect(e1)	 
end
function c67201550.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c67201550.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and Duel.GetTurnCount()~=c:GetTurnID()
end
function c67201550.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return chkc:IsLocation(LOCATION_GRAVE) and c67201550.filter(chkc)
		else
			return chkc:IsLocation(LOCATION_GRAVE) and c67201550.filter1(chkc) 
		end
	end
	local b1=Duel.IsExistingTarget(c67201550.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local b2=Duel.IsExistingTarget(c67201550.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(67201550,0),aux.Stringid(67201550,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(67201550,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(67201550,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,c67201550.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,PLAYER_ALL,LOCATION_GRAVE)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,c67201550.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,PLAYER_ALL,LOCATION_GRAVE)
	end
end
function c67201550.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e1:SetTarget(c67201550.distg)
			e1:SetLabelObject(tc)
			e1:SetLabel(Duel.GetTurnCount()) 
			e1:SetCondition(function(e) 
			return Duel.GetTurnCount()~=e:GetLabel() end) 
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
			--
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(c67201550.discon)
			e2:SetOperation(c67201550.disop)
			e2:SetLabelObject(tc)
			e2:SetLabel(Duel.GetTurnCount()) 
			e2:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e2,tp)
		end
	end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e1:SetTarget(c67201550.distg1)
			e1:SetLabelObject(tc)
			e1:SetLabel(Duel.GetTurnCount()) 
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			--
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(c67201550.discon1)
			e2:SetOperation(c67201550.disop1)
			e2:SetLabelObject(tc)
			e2:SetLabel(Duel.GetTurnCount()) 
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c67201550.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c67201550.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule()) and Duel.GetTurnCount()~=e:GetLabel()
end
function c67201550.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
--
function c67201550.distg1(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c67201550.discon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule()) 
end
function c67201550.disop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end