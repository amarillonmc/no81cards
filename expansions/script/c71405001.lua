--棱镜世界的观测者-阿希德
local s,id,o=GetID()
function s.initial_effect(c)
	if not (yume and yume.prism) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71405000,0)
		yume.import_flag=false
	end
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
	--banish and draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+100000)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(yume.prism.Cost)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	--separate xyz
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
	return c:IsSetCard(0x716) and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToRemoveAsCost()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filterc1,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and yume.prism.checkCounter(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filterc1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	yume.prism.regCostLimit(e,tp)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function s.filter2(c)
	return c:IsSetCard(0x716) and c:IsAbleToRemove()
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 and rc:IsLocation(LOCATION_REMOVED) then
		Duel.Draw(tp,1,REASON_EFFECT)
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
	return c:IsRankBelow(lv) and c:IsSetCard(0x716) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and (not recursive or Duel.IsExistingMatchingCard(s.filterc3,tp,LOCATION_EXTRA,0,1,c,lv-c:GetRank()+1,e,tp,false))
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local ft=Duel.GetMZoneCount(tp,c)
		local lv=c:GetLevel()
		return e:IsCostChecked() and lv>1
			and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
			and ft>1
			and Duel.IsExistingMatchingCard(s.filterc3,tp,LOCATION_EXTRA,0,1,nil,lv,e,tp,true)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) or
		Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local lv=e:GetLabel()
	local g1=Duel.SelectMatchingCard(tp,s.filterc3,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp,true)
	local tc1=g1:GetFirst()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,s.filterc3,tp,LOCATION_EXTRA,0,1,1,tc1,e,tp,lv-tc1:GetLevel()+1,false)
	g1:Merge(g2)
	for tc in aux.Next(g1) do
		tc:SetMaterial(nil)
		if Duel.SpecialSummonStep(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
			tc:CompleteProcedure()
		end
	end
	Duel.SpecialSummonComplete()
end