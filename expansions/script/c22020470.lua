--天草四郎阵中旗
local m = 22020470
local cm = _G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,22020430)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)  
end
function cm.matfilter(c,tp)
	return c:IsType(TYPE_LINK) and (c:IsControler(tp) or c:IsFaceup()) 
		and c:IsCanBeRitualMaterial(nil)
end
function cm.matfilter2(c,tp,rc)
	return c:IsCanBeRitualMaterial(rc) and (not c.mat_filter or c.mat_filter(c,tp))
end
function cm.gcheck(g,lv,tp,rc)
	return Duel.GetMZoneCount(tp,g,tp)>0 
		and g:CheckWithSumEqual(Card.GetLink,lv,1,99) 
			and (not rc.mat_group_check or rc.mat_group_check(g))
end
function cm.ritfilter(c,e,tp,mg,p,nev)
	mg = mg:Filter(cm.matfilter2,nil,tp,c)
	return c:IsType(TYPE_RITUAL) and (not nev or aux.NecroValleyFilter()(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
			and mg:CheckSubGroup(cm.gcheck,1,#mg,c:GetLevel(),tp,c)
				and (p==tp or (c:IsCode(22020430) and c:IsLocation(LOCATION_HAND))) 
end
function cm.spcheck(e,tp,nev) 
	local p=Duel.GetTurnPlayer()
	local mg=Duel.GetRitualMaterial(tp):Filter(cm.matfilter,nil,tp)
	if tp == p then
		local mg2=Duel.GetMatchingGroup(cm.matfilter,tp,0,LOCATION_MZONE,nil,tp)
		mg:Merge(mg2)
	end
	return Duel.IsExistingMatchingCard(cm.ritfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,p,nev),p,mg
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.spcheck(e,tp) end
	local sumloc = Duel.GetTurnPlayer()==tp and LOCATION_HAND+LOCATION_GRAVE or LOCATION_HAND 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,sumloc)
end
function cm.activate(e,tp)
	local res,p,mg = cm.spcheck(e,tp,true)
	if not res then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rc=Duel.SelectMatchingCard(tp,cm.ritfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg,p,true):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:SelectWithSumEqual(tp,Card.GetLink,rc:GetLevel(),1,99,rc)
	rc:SetMaterial(mat)
	Duel.ReleaseRitualMaterial(mat)
	Duel.BreakEffect()
	Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	rc:CompleteProcedure()
	Duel.BreakEffect()
	Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
end


