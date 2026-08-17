--默墟天使·终局之王
function c43990999.initial_effect(c)
	c:SetSPSummonOnce(43990999)
	aux.AddMaterialCodeList(c,43990998,43990995,43990992)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsCode,43990998),aux.FilterBoolFunction(Card.IsCode,43990995),nil,c43990999.mfilter,1,1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990999,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c43990999.thtg)
	e1:SetOperation(c43990999.thop)
	c:RegisterEffect(e1)
	--act qp/trap in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990999,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCondition(c43990999.handcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9510))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c43990999.chainop)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(43990999,2))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c43990999.drtg)
	e5:SetOperation(c43990999.drop)
	c:RegisterEffect(e5)
	if not SILENT_RUIN_EFFECT_HINT then
		SILENT_RUIN_EFFECT_HINT = true
		--CountLimit display
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:SetOperation(c43990999.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c43990999.mfilter(c,syncard,c1,c2,c3)
	return c:IsCode(43990992) and (c:IsTuner(syncard) or c1:IsTuner(syncard) or c2:IsTuner(syncard))
end
function c43990999.thfilter(c)
	return aux.IsCodeListed(c,43990999) and c:IsAbleToHand()
end
function c43990999.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990999.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c43990999.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c43990999.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c43990999.handcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c43990999.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x9510) then
		Duel.SetChainLimit(c43990999.chainlm)
	end
end
function c43990999.chainlm(e,rp,tp)
	return tp==rp
end
function c43990999.cfilter(c)
	return c:IsCode(43990992) and c:IsFaceupEx()
end
function c43990999.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c43990999.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c43990999.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c43990999.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.Draw(p,ct,REASON_EFFECT)
end
function c43990999.checkop(e,tp,eg,ep,ev,re,r,rp)
	local member_list={43990991,43990994,43990996,43990997}
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsCode,p,0xff,0,nil,table.unpack(member_list))
		if g:GetClassCount(Card.GetCode)==#member_list then
			local ge1=Effect.CreateEffect(e:GetHandler())
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_CUSTOM+43990999)
			ge1:SetOperation(c43990999.hintop)
			Duel.RegisterEffect(ge1,p)
		end
	end
	e:Reset()
end
function c43990999.hintop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp then return end
	--if r~=0 then return end
	local member_list={43990991,43990994,43990996,43990997}
	local code_ascver={43990991,43990994,43990996,43990997}--ascending order
	for _,te in pairs({Duel.IsPlayerAffectedByEffect(rp,EFFECT_FLAG_EFFECT+43990999)}) do te:Reset() end
	for i,code in pairs(member_list) do
		local ct=Duel.GetFlagEffectLabel(rp,code) or 0
		local te=Effect.CreateEffect(e:GetHandler())
		te:SetDescription(aux.Stringid(code_ascver[i],ct+3))
		te:SetType(EFFECT_TYPE_FIELD)
		te:SetCode(EFFECT_FLAG_EFFECT+43990999)
		te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		te:SetTargetRange(1,0)
		te:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(te,rp)
	end
end
