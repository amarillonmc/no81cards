--始祖龙的瑰宝
function c9910439.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910439+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910439.target)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c9910439.drcost)
	e2:SetTarget(c9910439.drtg)
	e2:SetOperation(c9910439.drop)
	c:RegisterEffect(e2)
	--check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_MOVE)
	e3:SetCondition(c9910439.regcon1)
	e3:SetOperation(c9910439.regop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c9910439.regcon2)
	e4:SetOperation(c9910439.regop2)
	c:RegisterEffect(e4)
end
function c9910439.setfilter(c,tp)
	local r=LOCATION_REASON_TOFIELD
	if c:IsControler(1-tp) then r=LOCATION_REASON_CONTROL end
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_SZONE,tp,r)>0
end
function c9910439.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c9910439.setfilter(chkc,tp) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c9910439.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(9910439,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c9910439.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectTarget(tp,c9910439.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,tp)
		if g:GetFirst():IsLocation(LOCATION_GRAVE) then
			Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
		end
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c9910439.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
function c9910439.drfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),TYPE_SPELL+TYPE_CONTINUOUS)==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToGraveAsCost()
end
function c9910439.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetFlagEffectLabel(9910439)
	local ft=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910439.drfilter,tp,LOCATION_ONFIELD,0,ct,nil) and ft>=ct end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910439.drfilter,tp,LOCATION_ONFIELD,0,ct,ct,nil)
	e:SetLabel(Duel.SendtoGrave(g,REASON_COST))
end
function c9910439.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c9910439.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9910439.regcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_SZONE) and Duel.GetTurnPlayer()==1-tp
end
function c9910439.regop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(9910439)
	if not ct then
		c:RegisterFlagEffect(9910439,RESET_EVENT+RESETS_STANDARD,0,1,1)
	end
end
function c9910439.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c9910439.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(9910439)
	if not ct then
		c:RegisterFlagEffect(9910439,RESET_EVENT+RESETS_STANDARD,0,1,1)
	else
		c:SetFlagEffectLabel(9910439,ct+1)
	end
end
