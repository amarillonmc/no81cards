--桃源乡的猎户
local m=11621410
local cm=_G["c"..m]
function c11621410.initial_effect(c)
	aux.AddCodeList(c,11621402)
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
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
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
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m*2+1)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3) 
	cm[c]=e3	 
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(cm.sumlimit)
	c:RegisterEffect(e4)  
end
cm.SetCard_THY_PeachblossomCountry=true 
--
function cm.sumlimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,700,0,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.posfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,700,0,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	--local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	--if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	--	local ag=Duel.SelectTarget(tp,cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	--	if ag:GetCount()>0 then
	--		Duel.HintSelection(ag)
	--		Duel.BreakEffect()
	--		Duel.ChangePosition(ag,POS_FACEDOWN_DEFENSE)
	--	end
	--end
end
--02
function cm.ntrfilter(c)
	return c.SetCard_THY_PeachblossomCountry and c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function cm.ntrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF and Duel.IsExistingMatchingCard(cm.ntrfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.ntrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0 and c:IsSSetable() end
end
function cm.ntrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SSet(tp,c)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1):GetFirst()
	Duel.ConfirmCards(tp,tc)
	if tc:IsType(TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetTargetRange(0,0x7f)
		e1:SetTarget(cm.crtg)
		e1:SetLabel(code)
		e1:SetValue(11621402)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetTargetRange(0,0x7f)
		e2:SetTarget(cm.crtg)
		e2:SetLabel(code)
		e2:SetValue(RACE_ZOMBIE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		--
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetTargetRange(0,0x7f)
		e3:SetTarget(cm.crtg)
		e3:SetLabel(code)
		e3:SetValue(ATTRIBUTE_LIGHT)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		--
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CHANGE_LEVEL)
		e4:SetTargetRange(0,0x7f)
		e4:SetTarget(cm.crtg2)
		e4:SetLabel(code)
		e4:SetValue(3)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	elseif tc:IsType(TYPE_SPELL) then
		if Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
			Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	else
		if tc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
			Duel.SSet(tp,tc)
		end
	end
	Duel.ShuffleHand(1-tp)
end
function cm.crtg(e,c)
	local code=e:GetLabel()
	return c:IsOriginalCodeRule(code)--c:IsCode(code)
end
function cm.crtg2(e,c)
	local code=e:GetLabel()
	return c:IsOriginalCodeRule(code) and c:IsLevelAbove(1)
end
--03
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,5,nil) end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil) 
	if g1:GetCount()<=4 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,5,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,5,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end