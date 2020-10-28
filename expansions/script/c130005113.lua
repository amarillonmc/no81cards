--耀变竜 梅丽娅
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005113,"DragonCaller")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	aux.AddSynchroProcedure(c,rsdc.IsSet,cm.synfilter,1)
	local e1=rsef.QO(c,EVENT_CHAINING,{m,0},nil,"neg,des,sp","dsp,dcal",LOCATION_EXTRA,cm.negcon,rscost.cost(cm.rmfilter,"rm",LOCATION_MZONE),cm.negtg,cm.negop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},nil,"td","de",nil,nil,rsop.target(Card.IsAbleToDeck,"td",0,LOCATION_ONFIELD,cm.tdct),cm.tdop)
	local e3=rsef.QO(c,EVENT_SUMMON,{m,2},nil,"diss,des,sp",nil,LOCATION_GRAVE,cm.discon,rscost.cost(cm.resfilter,"res",LOCATION_MZONE),cm.distg,cm.disop)
	local e4=rsef.RegisterClone(c,e3,"code",EVENT_SPSUMMON)
end
cm.material_type=TYPE_SYNCHRO
function cm.resfilter(c,e,tp)
	return cm.tdcfilter(c) and c:IsReleasable() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and rp~=tp
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)	
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.disop(e,tp,eg)
	local c=rscf.GetSelf(e)
	if c and rssf.SpecialSummon(c)>0 then
		Duel.NegateSummon(eg)
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.tdct(e,tp)
	return Duel.GetMatchingGroupCount(cm.tdcfilter,tp,LOCATION_GRAVE,0,nil)
end  
function cm.tdcfilter(c)
	return c:IsType(TYPE_SYNCHRO) and rsdc.IsSet(c)
end
function cm.tdop(e,tp)
	local tdct=cm.tdct(e,tp)
	rsop.SelectToDeck(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,tdct,tdct,nil,{})
end
function cm.synfilter(c)
	return c:IsSynchroType(TYPE_SYNCHRO) and c:IsRace(RACE_SPELLCASTER)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and Duel.IsChainNegatable(ev)
end
function cm.rmfilter(c,e,tp)
	return cm.tdcfilter(c) and c:IsFaceup() and c:IsAbleToRemoveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler())>0
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=rscf.GetSelf(e)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	if c and Duel.SpecialSummon(c,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
		c:CompleteProcedure()
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end   
	end
end