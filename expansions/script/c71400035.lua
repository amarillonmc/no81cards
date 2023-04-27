--梦行
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400035.initial_effect(c)
	--activate from hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(yume.nonYumeCon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71400035+EFFECT_COUNT_CODE_OATH)
	e1:SetDescription(aux.Stringid(71400035,0))
	e1:SetOperation(c71400035.op1)
	e1:SetTarget(c71400035.tg1)
	e1:SetCost(c71400035.cost1)
	e1:SetTarget(yume.YumeFieldCheckTarget())
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400035,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c71400035.con2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c71400035.tg2)
	e2:SetOperation(c71400035.op2)
	c:RegisterEffect(e2)
end
function c71400035.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c71400035.filter1(c)
	return c:IsSetCard(0xc714) and c:IsAbleToGrave()
end
function c71400035.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	if chk==0 then
		if c:IsLocation(LOCATION_ONFIELD) and c:IsFacedown() then
			return yume.YumeFieldCheck(tp,0,0,LOCATION_DECK+LOCATION_REMOVED) and Duel.IsExistingMatchingCard(c71400035.filter1,tp,LOCATION_DECK,0,1,nil)
		else
		return yume.YumeFieldCheck(tp,0,0,LOCATION_DECK+LOCATION_REMOVED)
		end
	end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		e:SetCategory(0)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function c71400035.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	yume.ActivateYumeField(e,tp,0,0,LOCATION_DECK+LOCATION_REMOVED)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0) and c:IsLocation(LOCATION_SZONE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c71400035.tg1a)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(c:GetSequence())
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetOperation(c71400035.op1a)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetLabel(c:GetSequence())
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(c71400035.tg1a)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetLabel(c:GetSequence())
		Duel.RegisterEffect(e3,tp)
	end
	if not c:IsStatus(STATUS_ACT_FROM_HAND) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c71400035.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c71400035.tg1a(e,c)
	local seq=e:GetLabel()
	local p=c:GetControler()
	local tp=e:GetHandlerPlayer()
	return not c:IsSetCard(0x714)
		and ((p==tp and c:GetSequence()==seq) or (p==1-tp and c:GetSequence()==4-seq))
end
function c71400035.op1a(e,tp,eg,ep,ev,re,r,rp)
	local tseq=e:GetLabel()
	local ec=re:GetHandler()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_MZONE~=0 then
		seq=aux.MZoneSequence(seq)
	elseif loc&LOCATION_SZONE~=0 then
		if seq>4 then return end
		seq=aux.SZoneSequence(seq)
	else
		return
	end
	if ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) and (not ec:IsSetCard(0x714) and ec:IsLocation(loc) or not (ec:IsPreviousSetCard(0x714) or ec:IsLocation(loc))) then
		Duel.NegateEffect(ev)
	end
end
function c71400035.con2(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and yume.YumeCon(e,tp) and Duel.IsAbleToEnterBP()
end
function c71400035.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71400035.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71400035.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c71400035.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c71400035.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x714)
end
function c71400035.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end