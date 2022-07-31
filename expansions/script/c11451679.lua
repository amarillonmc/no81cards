--秘仪伊甸
local m=11451679
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TOSS_COIN_NEGATE)
	e2:SetCondition(cm.coincon)
	e2:SetOperation(cm.coinop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_COIN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	if not ARCANA_EDEN then
		ARCANA_EDEN=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_TOSS_COIN)
		ge0:SetProperty(EFFECT_FLAG_DELAY)
		ge0:SetOperation(cm.tossop)
		Duel.RegisterEffect(ge0,0)
	end
end
cm.toss_coin=true
function cm.coincon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetCode()~=EVENT_TOSS_COIN_NEGATE
end
function cm.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		c:RegisterFlagEffect(m+tp,0,0,1)
		Duel.Hint(HINT_CARD,0,m)
		Duel.TossCoin(tp,ev)
		cm.coinop(e,1-tp,eg,ep,ev,re,r,rp)
	elseif Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		c:RegisterFlagEffect(m+1-tp,0,0,1)
		Duel.Hint(HINT_CARD,0,m)
		Duel.TossCoin(tp,ev)
		cm.coinop(e,tp,eg,ep,ev,re,r,rp)
	else
		local ct1=c:GetFlagEffect(m)
		local ct2=c:GetFlagEffect(m+1)
		c:ResetFlagEffect(m)
		c:ResetFlagEffect(m+1)
		if ct1>0 or ct2>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(m)
			e2:SetProperty(EFFECT_FLAG_DELAY)
			e2:SetLabel(ct1,ct2)
			e2:SetOperation(cm.drop)
			Duel.RegisterEffect(e2,0)
			Duel.RaiseEvent(c,m,e,0,0,0,0)
		end
	end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct1,ct2=e:GetLabel()
	Duel.Draw(tp,ct1,REASON_EFFECT)
	Duel.Draw(1-tp,ct2,REASON_EFFECT)
	e:Reset()
end
function cm.tossop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,m)>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return #tg>1 and c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,c)
	local res=Duel.TossCoin(tp,1)
	if res and #tg>0 then
		local sg=tg:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
	elseif res==0 and c:IsAbleToHand() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end