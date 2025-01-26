--秘计螺旋 破灭
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
		return tc and tc:IsAbleToRemove(POS_FACEDOWN)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ConfirmCards(tp,tc)
	if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_REMOVED) then return end
	local te=tc:CheckActivateEffect(false,true,false)
	if not te then return end
	local tpe=tc:GetType()
	local tg=te:GetTarget()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	if tg then
		if tc:IsSetCard(0x95) then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			tg(te,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then g=Group.CreateGroup() end
	for etc in aux.Next(g) do
		etc:CreateEffectRelation(te)
	end
	if op then
		if tc:IsSetCard(0x95) then
			op(e,tp,eg,ep,ev,re,r,rp)
		else
			op(te,tp,eg,ep,ev,re,r,rp)
		end
	end
	for etc in aux.Next(g) do
		etc:ReleaseEffectRelation(te)
	end
end
function s.rmfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(tp) and s.rmfilter(chkc,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c.tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		e1:SetLabel(Duel.GetTurnCount())
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(id)~=0
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	local b2=tc:IsSSetable()
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1)},
			{b2,aux.Stringid(id,2)},
			{true,aux.Stringid(id,3)})
	if op==1 then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) then
			Duel.ConfirmCards(1-tp,tc)
		end
	elseif op==2 then
		Duel.SSet(tp,tc)
	end
end