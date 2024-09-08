--忠武良弼 诸葛亮
function c98990000.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98990000,2))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c98990000.ttcon)
	e1:SetOperation(c98990000.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c98990000.setcon)
	c:RegisterEffect(e2)
	--confirm deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98990000,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PREDRAW)
	e4:SetCondition(c98990000.cfcon)
	e4:SetOperation(c98990000.cfop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98990000,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,98990000)
	e5:SetCondition(c98990000.condition)
	e5:SetCost(c98990000.acost)
	e5:SetTarget(c98990000.destg)
	e5:SetOperation(c98990000.desop)
	c:RegisterEffect(e5)
	--atkup
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98990000,1))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,9603253)
	e6:SetCost(c98990000.acost)
	e6:SetCondition(c98990000.condition)
	e6:SetTarget(c98990000.sptg)
	e6:SetOperation(c98990000.spop)
	c:RegisterEffect(e6)
	--to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(98990000,2))
	e7:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,9603254)
	e7:SetCost(c98990000.acost)
	e7:SetCondition(c98990000.condition)
	e7:SetTarget(c98990000.thtg)
	e7:SetOperation(c98990000.thop)
	c:RegisterEffect(e7)
	--add card
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCountLimit(1,98990000+EFFECT_COUNT_CODE_DUEL)
	e8:SetTarget(c98990000.actg)
	e8:SetOperation(c98990000.acop)
	c:RegisterEffect(e8)
end
function c98990000.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c98990000.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c98990000.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c98990000.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
end
function c98990000.cfop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local sp=Duel.GetTurnPlayer()
	local s1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local mp=s1*400
	if mp>14000 then mp=14000 end
	Duel.SetLP(tp,mp)
	local lp=Duel.GetLP(tp)
	local kp=math.floor(lp/2000)
	if Duel.GetFieldGroupCount(sp,LOCATION_DECK,0)<kp then return end
	Duel.SortDecktop(tp,sp,kp)
	if Duel.SelectOption(tp,aux.Stringid(19959742,1),aux.Stringid(19959742,2))==1 then
		for i=1,kp do
			local mg=Duel.GetDecktopGroup(sp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function c98990000.cfilter(c,code)
	return c:IsCode(code)
end
function c98990000.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c98990000.acost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98990000.cfilter,tp,LOCATION_HAND,0,1,nil,re:GetHandler():GetCode()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c98990000.cfilter,tp,LOCATION_HAND,0,1,1,nil,re:GetHandler():GetCode())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c98990000.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98990000.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c98990000.spfilter(c,e,tp)
	return c:IsSetCard(0x128) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98990000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c98990000.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c98990000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98990000.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c98990000.acfil(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function c98990000.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98990000.acfil,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
end
function c98990000.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c98990000.acfil,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		if tc:IsOnField() and tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
		local code=tc:GetCode()
		local rc=Duel.CreateToken(tp,code)
		Duel.SendtoHand(rc,tp,REASON_EFFECT)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVED)
		e2:SetRange(LOCATION_MZONE)
		e2:SetLabel(code)
		e2:SetCondition(c98990000.setcon1)
		e2:SetOperation(c98990000.setop1)
	   	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end
function c98990000.setcon1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local code=e:GetLabel()
	return Duel.GetFlagEffect(tp,98990000)==0 and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsCode(code) and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() and rc:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c98990000.setop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectEffectYesNo(tp,rc,aux.Stringid(952523,1)) then
		rc:CancelToGrave()
		Duel.ChangePosition(rc,POS_FACEDOWN)
		Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		Duel.RegisterFlagEffect(tp,98990000,RESET_PHASE+PHASE_END,0,0)
	end
end