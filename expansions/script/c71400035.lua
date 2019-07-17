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
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c71400035.op1)
	e1:SetTarget(c71400035.tg1)
	e1:SetTarget(yume.YumeFieldCheckTarget())
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
end
function c71400035.filter1(c)
	return c:IsSetCard(0xc714) and c:IsAbleToGrave()
end
function c71400035.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400035.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c71400035.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if yume.YumeFieldCheck(tp) and Duel.SelectYesNo(tp,aux.Stringid(71400035,1)) then
		yume.FieldActivation(tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71400035.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)==1 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0) then
		Duel.BreakEffect()
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
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local rct=1
	if Duel.GetTurnPlayer()~=tp then rct=2 end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetValue(c71400035.aclimit)
	e4:SetTargetRange(1,0)
	e4:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,rct)
	Duel.RegisterEffect(e4,tp)
end
function c71400035.aclimit(e,re,rp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and not rc:IsSetCard(0x714) and not rc:IsImmuneToEffect(e)
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
	seq=aux.MZoneSequence(seq)
	if ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) and (not ec:IsSetCard(0x714) and (ec:IsLocation(loc) or loc&LOCATION_ONFIELD==0) or not (ec:IsPreviousSetCard(0x714) or ec:IsLocation(loc)) and loc&LOCATION_ONFIELD~=0) then
		Duel.NegateEffect(ev)
	end
end