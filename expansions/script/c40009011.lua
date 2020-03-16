--圣金巫灵 沙漠之狂风
function c40009011.initial_effect(c)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009011,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40009011)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(c40009011.syncon)
	e1:SetTarget(c40009011.syntg)
	e1:SetOperation(c40009011.synop)
	c:RegisterEffect(e1) 
	--synchro level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetTarget(c40009011.syntg1)
	e3:SetValue(1)
	e3:SetOperation(c40009011.synop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(40009011)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)   
end
function c40009011.syncon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c40009011.synfilterq(c,tp)
	return c:IsFacedown() and c:IsType(TYPE_MONSTER)
end
function c40009011.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009011.synfilterq(chkc,tp,c) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c40009011.synfilterq,tp,LOCATION_MZONE,0,1,nil,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,c40009011.synfilterq,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SelectTarget(tp,c40009011.synfilterq,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c40009011.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local tc=Duel.GetFirstTarget()
	if Duel.ChangePosition(tc,POS_FACEUP)~=0 and tc:GetRace(RACE_ROCK) and Duel.SelectYesNo(tp,aux.Stringid(40009011,1)) then
			Duel.BreakEffect()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local mg=Group.FromCards(c,tc)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
end
function c40009011.cardiansynlevel(c)
	return 3
end
function c40009011.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function c40009011.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=c40009011.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(c40009011.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function c40009011.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
		and (g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
			or g:CheckWithSumEqual(c40009011.cardiansynlevel,lv,ct,ct,syncard))
end
function c40009011.syntg1(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() and lv<=c40009011.cardiansynlevel(c) then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(c40009011.synfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	return mg:IsExists(c40009011.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c40009011.synop1(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(c40009011.synfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	for i=1,maxc do
		local cg=mg:Filter(c40009011.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c40009011.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	Duel.SetSynchroMaterial(g)
end
