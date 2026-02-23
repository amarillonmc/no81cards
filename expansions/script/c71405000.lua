--棱镜世界的观测者-莉兹
local s,id,o=GetID()
yume=yume or {}
function s.initial_effect(c)
	if yume.import_flag then return	end
	yume.prism.addCounter()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCountLimit(1,id)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--to hand or set s/t
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+100000)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(yume.prism.Cost)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	--separate synchro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+110000)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	e3:SetCost(s.cost3)
	c:RegisterEffect(e3)
end
function s.filterc1(c)
	return c:IsSetCard(0x716) and c:IsAbleToRemoveAsCost()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filterc1,tp,LOCATION_HAND,0,1,e:GetHandler())
		and yume.prism.checkCounter(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filterc1,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	yume.prism.regCostLimit(e,tp)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function s.filter2(c)
	return c:IsSetCard(0x716) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return yume.prism.checkCounter(tp) and c:IsAbleToRemoveAsCost() end
	e:SetLabel(c:GetLevel())
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	yume.prism.regCostLimit(e,tp)
end
function s.filterc3(c,lv,e,tp,recursive)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x716) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and (not recursive or Duel.IsExistingMatchingCard(s.filterc3,tp,LOCATION_EXTRA,0,1,c,lv-c:GetLevel()+1,e,tp,false))
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local ft=Duel.GetMZoneCount(tp,c)
		local lv=c:GetLevel()
		return e:IsCostChecked() and lv>1
			and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
			and ft>1
			and Duel.IsExistingMatchingCard(s.filterc3,tp,LOCATION_EXTRA,0,1,nil,lv,e,tp,true)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) or
		Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_SYNCHRO)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local lv=e:GetLabel()
	local g1=Duel.SelectMatchingCard(tp,s.filterc3,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp,true)
	local tc1=g1:GetFirst()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,s.filterc3,tp,LOCATION_EXTRA,0,1,1,tc1,lv-tc1:GetLevel()+1,e,tp,false)
	g1:Merge(g2)
	for tc in aux.Next(g1) do
		tc:SetMaterial(nil)
		if Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) then
			tc:CompleteProcedure()
		end
	end
	Duel.SpecialSummonComplete()
end
if not yume.prism then
yume.prism={}
function yume.prism.addCounter()
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,yume.prism.CounterFilter)
end
function yume.prism.checkCounter(tp)
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0
end
function yume.prism.Cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return yume.prism.checkCounter(tp) end
	yume.prism.regCostLimit(e,tp)
end
function yume.prism.CounterFilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
		or not c:IsLocation(LOCATION_MZONE) and c:GetPreviousSequence()<5
end
function yume.prism.regCostLimit(e,tp)
	--zone limit
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(0x1f001f)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function yume.prism.AcLimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function yume.AddThisCardBanishedAlreadyCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(aux.ThisCardInGraveAlreadyCheckReg)
	c:RegisterEffect(e1)
	return e1
end
end