--桃源乡的美妇人
local m=11621407
local cm=_G["c"..m]
function c11621407.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--ntr
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_CONTROL) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.ntrcon)
	e2:SetTarget(cm.ntrtg)
	e2:SetOperation(cm.ntrop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m*2+1)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3) 
	cm[c]=e3 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,1100,900,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.filter(c)
	return c:IsFaceup() and not c:IsAttack(0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,1100,900,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	--local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
	--if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	--  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	--  local ag=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
	--  if ag:GetCount()>0 then
	--  Duel.HintSelection(ag)
	--  Duel.BreakEffect()
	--  local e1=Effect.CreateEffect(e:GetHandler())
	--   e1:SetType(EFFECT_TYPE_SINGLE)
	--  e1:SetCode(EFFECT_UPDATE_ATTACK)
	--  e1:SetValue(-1000)
	--  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	--  ag:GetFirst():RegisterEffect(e1)
	--  end
	--end
end
--02
function cm.ntrfilter(c)
	return c:IsSetCard(0x5220) and c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function cm.ntrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF and Duel.IsExistingMatchingCard(cm.ntrfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.ntrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil,true) and c:IsSSetable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil,true)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),1-tp,LOCATION_MZONE)
end
function cm.ntrop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:IsSSetable() and not tc:IsImmuneToEffect(e) then
		Duel.SSet(tp,c)
		if tc:IsFaceup() and tc:IsControlerCanBeChanged() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_ZOMBIE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			--local e2=Effect.CreateEffect(c)
			--e2:SetType(EFFECT_TYPE_SINGLE)
			--e2:SetCode(EFFECT_CANNOT_ATTACK)
			--e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			--tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetValue(ATTRIBUTE_LIGHT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e5=e3:Clone()
			e5:SetCode(EFFECT_CHANGE_LEVEL)
			e5:SetValue(3)
			tc:RegisterEffect(e5)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_CHANGE_CODE)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetValue(11621402)
			tc:RegisterEffect(e4)
		end
	Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
--03
function cm.thfilter(c)
	return c:IsSetCard(0x5220) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
