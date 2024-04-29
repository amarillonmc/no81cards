--桃源乡的来访者
local m=11621402
local cm=_G["c"..m]
function c11621402.initial_effect(c)
	c:EnableReviveLimit() 
	--Atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1) 
	--special summon (hand/grave)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.spcost)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	--set1
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCountLimit(1,m*2+1)
	e5:SetCost(cm.stcost)
	e5:SetTarget(cm.sttg)
	e5:SetOperation(cm.stop)
	c:RegisterEffect(e5)   
	--set2
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCountLimit(1,m*3+1)
	e6:SetCost(cm.spcost)
	e6:SetTarget(cm.settg)
	e6:SetOperation(cm.setop)
	c:RegisterEffect(e6)
end
function cm.atkfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsFaceup() and c:IsSetCard(0x5220)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*800
end
--01
function cm.rfilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x5220) and (c:IsReleasable() or c:IsLocation(LOCATION_HAND))
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function cm.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsControlerCanBeChanged() end
	Duel.GetControl(c,1-tp,PHASE_END,1)
end
function cm.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(cm.setfilter,tp,LOCATION_ONFIELD,0,nil)
	local loc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function cm.thfilter(c)
	return c:IsFacedown() and c:IsAbleToHand() 
end
function cm.setfilter(c)
	return c:IsSSetable() and c:IsSetCard(0x5220) and c:IsType(TYPE_TRAP)
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_ONFIELD,0,nil) 
	if g:GetCount()>0 then  
		local rg=g:Select(tp,1,99,nil) 
		if Duel.SendtoHand(rg,nil,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
			local ft=Duel.GetLocationCount(tp,LOCATION_SZONE) 
			local sg=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_HAND,0,1,ft,nil) 
			Duel.SSet(tp,sg) 
			for tc in aux.Next(sg) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end 
		end 
	end
end
--03
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end