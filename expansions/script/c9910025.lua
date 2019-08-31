--栖居铁镜的神明 绫濑
function c9910025.initial_effect(c)
	--to hand & remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910025+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c9910025.cost)
	e1:SetTarget(c9910025.target)
	e1:SetOperation(c9910025.operation)
	c:RegisterEffect(e1)
end
function c9910025.thfilter(c)
	return (c:IsSetCard(0x950) or c:IsSetCard(0x951)) and c:IsAbleToHand()
end
function c9910025.rpfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function c9910025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=2
	if not Duel.IsExistingMatchingCard(c9910025.thfilter,tp,LOCATION_DECK,0,1,nil) then rt=rt-1 end
	if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) then rt=rt-1 end
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c9910025.rpfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	local ct=0
	if rt>=1 then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910025,0))
		local g=Duel.SelectMatchingCard(tp,c9910025.rpfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
		if g:GetCount()==0 then return end
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		ct=ct+1
	end
	if rt>=2 and Duel.IsExistingMatchingCard(c9910025.rpfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(9910025,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910025,0))
		local g=Duel.SelectMatchingCard(tp,c9910025.rpfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
		if g:GetCount()==0 then return end
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		ct=ct+1
	end
	e:SetLabel(ct)
end
function c9910025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c9910025.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local ct=e:GetLabel()
	local sel=0
	local off=0
	repeat
		local ops={}
		local opval={}
		off=1
		if b1 then
			ops[off]=aux.Stringid(9910025,2)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(9910025,3)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			sel=sel+1
			b1=false
		else
			sel=sel+2
			b2=false
		end
		ct=ct-1
	until ct==0 or off<3
	e:SetLabel(sel)
	if bit.band(sel,1)~=0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if bit.band(sel,2)~=0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_MZONE)
	end
end
function c9910025.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if bit.band(sel,1)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910025.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if bit.band(sel,2)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_ONFIELD,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_RULE)
		end
	end
end
