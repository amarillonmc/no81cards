--波动神智·点阵波雷达
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK+TIMING_END_PHASE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
end
function cm.filter(c,tp)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,1500,1500,c:GetLevel(),RACE_PSYCHO,ATTRIBUTE_LIGHT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	e:SetLabel(tc:GetLevel())
	Duel.Remove(tc,POS_FACEDOWN,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,1500,1500,lv,RACE_PSYCHO,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_EFFECT,nil,nil,lv,nil,nil)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		c:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.filter2(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function cm.filter3(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_REMOVED)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,5,nil)
	Duel.ConfirmCards(tp,tg)
	if tg:GetCount()==0 then return end
	if Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)==0 then return end
	local ct1=Duel.GetOperatedGroup():FilterCount(cm.filter3,nil,tp)
	local ct2=Duel.GetOperatedGroup():FilterCount(cm.filter3,nil,1-tp)
	if ct1>0 then Duel.SortDecktop(tp,tp,ct1) end
	if ct2>0 then Duel.SortDecktop(tp,1-tp,ct2) end
end