--镜中故你
function c60158201.initial_effect(c)
	aux.AddCodeList(c,60158001,60158101)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60158201+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c60158201.target)
	e1:SetOperation(c60158201.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c60158201.regcon)
	e2:SetOperation(c60158201.regop)
	c:RegisterEffect(e2)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e22:SetCode(EVENT_REMOVE)
	e22:SetCondition(c60158201.regcon)
	e22:SetOperation(c60158201.regop)
	c:RegisterEffect(e22)
	--2xg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60158201,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCondition(c60158201.setcon)
	e3:SetTarget(c60158201.settg)
	e3:SetOperation(c60158201.setop)
	c:RegisterEffect(e3)
	
end

function c60158201.filter(c)
	return c:IsFaceup() and c:IsCode(60158101) and not c:IsType(TYPE_TOKEN) and c:GetFlagEffect(60158201)==0
end
function c60158201.filter2(c)
	return c:IsCode(60158001)
end
function c60158201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60158201.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60158201.filter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c60158201.filter2,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60158201.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60158201.cfilter(c,tc)
	return c:IsCode(60158001)
end
function c60158201.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c60158201.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	local ec=cg:GetFirst()
	local code=ec:GetCode()
	if not tc:IsType(TYPE_EFFECT) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(code)
	tc:RegisterEffect(e1)
	tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	tc:RegisterFlagEffect(60158201,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(60158201,0))
end

--2xg

function c60158201.regcon(e,tp,eg,ep,ev,re,r,rp)
	local code1,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	return e:GetHandler():IsReason(REASON_COST) and re and re:IsActivated() and (code1==60158001 or code2==60158001)
end
function c60158201.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(60158201,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c60158201.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(60158201)>0 and e:GetHandler():IsFaceup()
end
function c60158201.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60158201.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if ct==1 then
			 Duel.BreakEffect()
			 Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end