--红莲魔龙的升华
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMING_ATTACK)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_BATTLE_PHASE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(aux.bpcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.attg)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
end
function s.filter1(c,e,tp,rg)
	local clv=c:GetLevel()
	return c:IsSetCard(0x1045) and clv>0 and c:IsAbleToDeck()
		and c:IsFaceup()
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,clv,rg)
end
function s.filter2(c,e)
	local clv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and clv>0 and c:IsAbleToDeck()
		and c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function s.spfilter(c,e,tp,lv,rg)
	local clv=c:GetLevel()
	return c:IsSetCard(0x1045)
		and c:IsType(TYPE_SYNCHRO) and clv>lv 
		and rg:Filter(Card.IsLevelBelow,nil,clv-lv):GetCount()>0 
		and rg:CheckWithSumEqual(Card.GetOriginalLevel,clv-lv,1,99)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.spfilter2(c,e,tp,lv)
	local clv=c:GetLevel()
	return c:IsSetCard(0x1045)
		and c:IsType(TYPE_SYNCHRO) and clv==lv 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.chkfilter(c,e,tp)
	return c:IsSetCard(0x1045)
		and c:IsType(TYPE_SYNCHRO) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.synfilter(c,g,lv)
	return c:IsSetCard(0x1045)
		and c:IsType(TYPE_SYNCHRO) 
		and (g:GetSum(Card.GetLevel)+lv)==c:GetLevel()
end
function s.fselect(g,tp,lv)
	return Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,g,lv)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp,rg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp,rg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local cg=Duel.GetMatchingGroup(s.chkfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local _,maxlevel=cg:GetMaxGroup(Card.GetLevel)
	local rg=rg:Filter(Card.IsLevelBelow,nil,maxlevel-g1:GetFirst():GetLevel())
	local g2=rg:SelectSubGroup(tp,s.fselect,false,1,math.min(maxlevel-g1:GetFirst():GetLevel(),rg:GetCount()),tp,g1:GetFirst():GetLevel())
	Duel.SetTargetCard(g2)
	g1:Merge(g2)
	e:SetLabel(g1:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local gc=e:GetLabel()
	local tg=Duel.GetTargetsRelateToChain()
	if #tg==gc and Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)==gc then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK|LOCATION_EXTRA)
		local lv=og:GetSum(Card.GetLevel)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1045) and c:IsType(TYPE_SYNCHRO) 
end
function s.tgfilter(c)
	return c:IsSetCard(0x57) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.atkfilter(chkc) end
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
		if ct<=0 or g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,ct,nil)
		if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetValue(og:GetCount())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
