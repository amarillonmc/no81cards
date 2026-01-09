--L-J幻象！
---@param c Card
function c71403023.initial_effect(c)
	if not (yume and yume.PPT_loaded) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71403001,0)
		yume.import_flag=false
	end
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403023,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetTarget(c71403023.tg1)
	e1:SetOperation(c71403023.op1)
	c:RegisterEffect(e1)
	yume.RegPPTSTGraveEffect(c,71403023)
	yume.PPTCounter()
end
function c71403023.filtertg1(c,tp)
	return c:GetOriginalType()&TYPE_PENDULUM~=0 and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c71403023.filter1,tp,LOCATION_DECK,0,1,nil,c:GetCurrentScale())
end
function c71403023.filter1(c,scale)
	return c:IsSetCard(0x715) and c:IsType(TYPE_PENDULUM) and c:GetCurrentScale()~=scale and c:IsAbleToHand()
end
function c71403023.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c71403023.filtertg1(chkc,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c71403023.filtertg1,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c71403023.filtertg1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71403023.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local th_flag=false
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local scale=tc:GetCurrentScale()
		local thg=Duel.SelectMatchingCard(tp,c71403023.filter1,tp,LOCATION_DECK,0,1,1,nil,scale)
		if thg:GetCount()>0 then
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
			thg=Duel.GetOperatedGroup()
			th_flag=thg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND)
		end
	end
	if th_flag and (Duel.CheckLocation(tp,LOCATION_PZONE,0)
		or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		local pg=Duel.GetMatchingGroup(yume.PPTPlacePendExceptFromFieldFilter,tp,LOCATION_DECK,0,nil)
		local bg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,nil,tp)
		if pg:GetCount()>0 and bg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71403023,1)) then
			Duel.BreakEffect()
			local c=e:GetHandler()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rc=bg:Select(tp,1,1,nil):GetFirst()
			if Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				rc:RegisterFlagEffect(71403023,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabelObject(rc)
				e1:SetCountLimit(1)
				e1:SetCondition(c71403023.retcon)
				e1:SetOperation(c71403023.retop)
				Duel.RegisterEffect(e1,tp)
			else
				return
			end
			local ct=0
			if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
			if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
			ct=math.min(ct,pg:GetCount())
			if ct==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local spg=pg:Select(tp,ct,ct,nil)
			for pc in aux.Next(spg) do
				Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
			if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,2,nil,0x715) then
				yume.OptionalPendulum(e,c,tp)
			end
		end
	end
end
function c71403023.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(71403023)~=0
end
function c71403023.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end