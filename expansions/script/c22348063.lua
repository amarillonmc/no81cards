--红 之 印 象 金 黄 失 落 之 国
local m=22348063
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(c22348063.Condition)
	e0:SetTarget(c22348063.target)
	e0:SetOperation(c22348063.operation)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--set2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348063,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c22348063.target)
	e2:SetOperation(c22348063.operation)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348063,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22348063.spcon)
	e3:SetTarget(c22348063.thtg)
	e3:SetOperation(c22348063.thop)
	c:RegisterEffect(e3)
	if not c22348063.global_check then
		c22348063.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c22348063.checkop1)
		Duel.RegisterEffect(ge1,0)
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function c22348063.filter1(c)
	return c:IsOriginalCodeRule(22348063) and c:IsFacedown() and c:IsHasEffect(EFFECT_CHANGE_TYPE) and c:IsType(TYPE_TRAP) and c:GetOriginalType()~=TYPE_TRAP
end
function c22348063.filter2(c)
	return c:IsOriginalCodeRule(22348063) and c:IsFaceup() and c:GetOriginalType()~=0x200021
end
function c22348063.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(c22348063.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local g2=Duel.GetMatchingGroup(c22348063.filter2,tp,0xff,0xff,nil)
	if KOISHI_CHECK and g1:GetCount()>0 then
		g1:GetFirst():SetCardData(CARDDATA_TYPE,0x4)
	end
	if KOISHI_CHECK and g2:GetCount()>0 then
		g2:GetFirst():SetCardData(CARDDATA_TYPE,0x200021)
	end
end
function c22348063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
end
function c22348063.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
		or not Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(g1)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
	local g2=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,0,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(g2)
	local c1=g1:GetFirst()
	local c2=g2:GetFirst()
			 if c1 and c2 then
			  Duel.MoveToField(c1,1-tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetCode(EFFECT_CHANGE_TYPE)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			  e1:SetValue(TYPE_TRAP)
			  c1:RegisterEffect(e1)
			  Duel.MoveToField(c2,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetCode(EFFECT_CHANGE_TYPE)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			  e1:SetValue(TYPE_TRAP)
			  c2:RegisterEffect(e1)
			 end
end
function c22348063.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetType()==TYPE_TRAP
end
function c22348063.thfilter(c)
	return c:IsSetCard(0x3702) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c22348063.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348063.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c22348063.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c22348063.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c22348063.Condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetType()==TYPE_TRAP and (Duel.GetTurnCount()~=c:GetTurnID() or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN))
end






