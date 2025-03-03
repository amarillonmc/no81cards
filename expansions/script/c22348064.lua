--惧质体 “小丑”
local m=22348064
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_EQUIP+CATEGORY_CONTROL)
	e0:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(c22348064.Condition)
	e0:SetTarget(c22348064.target)
	e0:SetOperation(c22348064.operation)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--set2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348064,0))
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c22348064.target)
	e2:SetOperation(c22348064.operation)
	c:RegisterEffect(e2)
	--ps
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348060,2))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22348064.pscon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c22348064.pstg)
	e3:SetOperation(c22348064.psop)
	c:RegisterEffect(e3)
	if not c22348064.global_check then
		c22348064.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c22348064.checkop1)
		Duel.RegisterEffect(ge1,0)
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function c22348064.filter1(c)
	return c:IsOriginalCodeRule(22348064) and c:IsFacedown() and c:IsHasEffect(EFFECT_CHANGE_TYPE) and c:IsType(TYPE_TRAP) and c:GetOriginalType()~=TYPE_TRAP
end
function c22348064.filter2(c)
	return c:IsOriginalCodeRule(22348064) and c:IsFaceup() and c:GetOriginalType()~=0x200021
end
function c22348064.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(c22348064.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local g2=Duel.GetMatchingGroup(c22348064.filter2,tp,0xff,0xff,nil)
	if KOISHI_CHECK and g1:GetCount()>0 then
		g1:GetFirst():SetCardData(CARDDATA_TYPE,0x4)
	end
	if KOISHI_CHECK and g2:GetCount()>0 then
		g2:GetFirst():SetCardData(CARDDATA_TYPE,0x200021)
	end
end
function c22348064.tgfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsAbleToChangeControler()
		and Duel.IsExistingMatchingCard(c22348064.eqfilter,tp,LOCATION_DECK,0,1,nil)
end
function c22348064.eqfilter(c)
	return c:IsSetCard(0x3702) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c22348064.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c22348064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c22348064.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22348064.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c22348064.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=Duel.SelectMatchingCard(tp,c22348064.eqfilter,tp,LOCATION_DECK,0,1,1,nil)
	local sc=sg:GetFirst()
	if sc then
		if not Duel.Equip(tp,sc,tc) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c22348064.eqlimit)
		e1:SetLabelObject(tc)
		sc:RegisterEffect(e1)
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
function c22348064.pscon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetType()==TYPE_TRAP
end
function c22348064.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c22348064.psop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if g:GetCount()>0 and ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg1=g:Select(tp,1,ct,nil)
		if sg1:GetCount()>0 then
			Duel.HintSelection(sg1)
			local aaa=Duel.ChangePosition(sg1,POS_FACEDOWN_DEFENSE)
			if aaa>0 then
				Duel.Draw(tp,aaa,REASON_EFFECT)
			end
		end
	end
end
function c22348064.Condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetType()==TYPE_TRAP and (Duel.GetTurnCount()~=c:GetTurnID() or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN))
end






