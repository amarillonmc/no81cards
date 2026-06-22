--散漫日常-芈祢
function c16191800.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetDescription(aux.Stringid(16191800,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCountLimit(1,16191800)
	e1:SetCost(c16191800.cost)
	e1:SetTarget(c16191800.target)
	e1:SetOperation(c16191800.operation)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(c16191800.lvval)
	c:RegisterEffect(e2)
	--[[--level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(c16191800.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c16191800.lvcon)
	e3:SetOperation(c16191800.lvop)
	c:RegisterEffect(e3)]]
	--
	Duel.AddCustomActivityCounter(16191800,ACTIVITY_CHAIN,aux.FALSE)
end
function c16191800.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	e:SetLabel(e:GetHandler():GetLevel())
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c16191800.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then
		if not e:IsCostChecked() or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<lv then return false end
		local g=Duel.GetDecktopGroup(1-tp,lv)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
end
function c16191800.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac_s=0
	if Duel.GetTurnPlayer()==tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		ac_s=Duel.AnnounceCard(tp)
	end
	--
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac_o=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	--
	if Duel.GetTurnPlayer()~=tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		ac_s=Duel.AnnounceCard(tp)
	end
	--confirm
	local res=false
	local ct=e:GetLabel()
	Duel.ConfirmDecktop(1-tp,ct)
	local g=Duel.GetDecktopGroup(1-tp,ct)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		local tg=g:Filter(Card.IsAbleToHand,nil)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local sg=tg:Select(1-tp,1,1,nil)
			if sg:GetFirst():IsCode(ac_o) then res=true end
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,sg)
		end
		Duel.ShuffleDeck(1-tp)
	end
	if not res then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c16191800.distg1)
		e1:SetLabel(ac_o,ac_s)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c16191800.discon)
		e2:SetOperation(c16191800.disop)
		e2:SetLabel(ac_o,ac_s)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(c16191800.distg2)
		e3:SetLabel(ac_o,ac_s)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c16191800.distg1(e,c)
	return c:IsOriginalCodeRule(e:GetLabel()) and (c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c16191800.distg2(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function c16191800.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOriginalCodeRule(e:GetLabel())
end
function c16191800.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c16191800.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(16191800,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function c16191800.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetFlagEffect(16191800)~=0
end
function c16191800.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLevelBelow(2) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(-1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c16191800.atkval(e,c)
	local ct=Duel.GetCustomActivityCount(16191800,1-e:GetHandlerPlayer(),ACTIVITY_CHAIN)
	if ct>=9 then ct=9 end
	return -ct
end
