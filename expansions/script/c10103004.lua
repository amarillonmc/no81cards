--界限龙王 乌鲁姆
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103004
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.FilterBoolFunction(Card.IsAttackAbove,2000),false)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"se,th",nil,LOCATION_MZONE,nil,rscost.cost(cm.resfilter,"res"),rstg.target2(cm.fun,rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.thop)
	local e2=rsef.FTO(c,EVENT_TO_GRAVE,{m,1},{1,m+100},"sp","tg,dsp,de",LOCATION_GRAVE,nil,rscost.cost(Card.IsAbleToExtraAsCost,"te"),cm.sptg,cm.spop)
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_REMOVE)
end
function cm.spfilter2(c,e,tp)
	return c:GetPreviousRaceOnField()&RACE_DRAGON ~=0 and c:IsRace(RACE_DRAGON) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup() and c:IsReason(REASON_BATTLE)))
end
function cm.spop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then
		rssf.SpecialSummon(tc)
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.spfilter2,1,c,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	rsof.SelectHint(tp,"sp")
	local sg=eg:FilterSelect(tp,cm.spfilter2,1,1,c,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0) 
end
function cm.resfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsReleasable()
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.thfilter(c)
	return c:IsSetCard(0x337) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.actfilter(c,tp)
	return c:IsCode(10103016) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.thop(e,tp,eg)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tg)
		local ag=Duel.GetMatchingGroup(cm.actfilter,tp,LOCATION_DECK,0,nil,tp)
		if #ag>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			rsof.SelectHint(tp,HINTMSG_SELF)
			local tc=ag:Select(tp,1,1,nil):GetFirst()
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end