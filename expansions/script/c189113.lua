if ven then return end
ven=ven or {}
function ven.set(code,setcode,rkflag)
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	return code,_G["c"..code]
end
local m,cm=ven.set(189113)
cm.name="恒夜的略影"
ven=cm
function ven.EnableSpiritReturn(c,op,cat,event1,...)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(event1)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(cm.SpiritReturnReg(op,cat))
	c:RegisterEffect(e1)
	for i,event in ipairs{...} do
		local e2=e1:Clone()
		e2:SetCode(event)
		c:RegisterEffect(e2)
	end
end
function cm.SpiritReturnReg(op,cat)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND|cat)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0xd6e0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(cm.SpiritReturnConditionForced)
	e1:SetTarget(aux.SpiritReturnTargetForced)
	e1:SetOperation(cm.SpiritReturnOperation(op))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(cm.SpiritReturnConditionOptional)
	e2:SetTarget(aux.SpiritReturnTargetOptional)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	end)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE end)
	e3:SetOperation(cm.SpiritReturnOperation(op))
	c:RegisterEffect(e3)
end
end
function cm.SpiritReturnConditionForced(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)==0 and not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
end
function cm.SpiritReturnConditionOptional(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)==0 and not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
end
function cm.SpiritReturnOperation(op)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		if Duel.GetCurrentPhase()==PHASE_BATTLE_START then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetTurnCount()~=e:GetLabel()end)
			e1:SetReset(RESET_PHASE+PHASE_BATTLE_START,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_BATTLE_START)
		end
		e1:SetCountLimit(1)
		e1:SetOperation(op)
		Duel.RegisterEffect(e1,tp)
	end
end
end
if not cm then return end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,nil) and (Duel.IsPlayerCanSummon(tp) or Duel.IsPlayerCanDraw(tp,1) or Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,exc)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.filter(c)
	return (c:IsSummonable(true,nil) or c:IsMSetable(true,nil)) and c:IsType(TYPE_SPIRIT)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_HAND) then return end
	local b1=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsPlayerCanDraw(tp,1)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	local b3=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,exc)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	Duel.BreakEffect()
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
		if tc then
			if tc:IsSummonable(true,nil) and (not tc:IsMSetable(true,nil) or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then Duel.Summon(tp,tc,true,nil) else Duel.MSet(tp,tc,true,nil) end
		end
	elseif opval[op]==2 then
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,exc)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsType(TYPE_SPIRIT)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
