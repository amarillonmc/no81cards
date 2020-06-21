--狱影军-建御雷
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(130001245)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lfilter,2)
	local e1=rsef.QO(c,nil,{m,0},nil,"sp",nil,LOCATION_EXTRA,cm.spcon,cm.spcost,rsop.target(aux.TRUE,"sp"),cm.spop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},nil,"sp,tg","de,dsp",rscon.sumtype("link"),nil,cm.eftg,cm.efop)
end
function cm.lfilter(c)
	return c:IsLinkType(TYPE_PENDULUM) and not c:IsAttribute(ATTRIBUTE_DARK) and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.spcon(e,tp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function cm.rmfilter(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function cm.gcheck(g,e,tp)
	local c=e:GetHandler()
	return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,rsloc.ho+LOCATION_EXTRA,0,nil)
	if chk==0 then return g:CheckSubGroup(cm.gcheck,2,#g,e,tp) end
	rshint.Select(tp,"rm")
	local rg=g:SelectSubGroup(tp,cm.gcheck,false,2,#g,e,tp)
	local ct=Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(ct)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c and rssf.SpecialSummon(c,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)>0 then
		c:CompleteProcedure()
		c:RegisterFlagEffect(m,rsreset.est,0,1,e:GetLabel())
	end
end
function cm.tgfilter(c)
	local g=c:GetColumnGroup()
	g:AddCard(c)
	return g:IsExists(Card.IsAbleToGrave,1,nil)
end
function cm.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(rscf.spfilter2(Card.IsType,TYPE_PENDULUM),tp,LOCATION_REMOVED,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b3=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 or b3 end
end
function cm.efop(e,tp)
	local c=e:GetHandler()
	local ct=1
	if c:IsRelateToEffect(e) and c:GetFlagEffectLabel(m) then
		ct=math.floor(c:GetFlagEffectLabel(m)/2)
	end
	for i=1,ct do
		local b1=Duel.IsExistingMatchingCard(rscf.spfilter2(Card.IsType,TYPE_PENDULUM),tp,LOCATION_REMOVED,0,1,nil,e,tp)
		local b2=Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		local b3=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		if not b1 and not b2 and not b3 then return end
		if i>1 and not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
		local op=rsop.SelectOption(tp,b1,{m,3},b2,{m,4},b3,{m,5})
		if op==1 then
			rsop.SelectSpecialSummon(tp,rscf.spfilter2(Card.IsType,TYPE_PENDULUM),tp,LOCATION_REMOVED,0,1,1,nil,{},e,tp)
		elseif op==2 then
			rsop.SelectSolve(HINTMSG_TOGRAVE,tp,cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cm.tgfun)
		elseif op==3 then
			rsop.SelectSolve(HINTMSG_TOGRAVE,tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cm.tgfun2,tp)
		end
	end
end
function cm.tgfun(g)
	local cg=g:GetFirst():GetColumnGroup()
	cg:Merge(g)
	Duel.SendtoGrave(cg,REASON_EFFECT)
	return true
end
function cm.tgfilter2(c,og)
	return og:IsExists(cm.tgfilter3,1,nil,c)
end
function cm.tgfilter3(c,tc)
	local seq1=c:GetPreviousSequence()
	local loc1=c:GetPreviousLocation()
	local tp1=c:GetPreviousControler()
	local seq2=tc:GetSequence()
	return tc:IsLocation(loc1) and seq1<5 and seq2<5 and math.abs(seq1-seq2)==1 and tc:IsControler(tp1) and tc:IsAbleToGrave()
end
function cm.tgfun2(g,tp)
	local tc=g:GetFirst()
	if Duel.SendtoGrave(g,REASON_EFFECT)<=0 then return false end
	local nearg=Duel.GetMatchingGroup(cm.tgfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,Duel.GetOperatedGroup())
	while #nearg>0 do
		Duel.BreakEffect()
		Duel.SendtoGrave(nearg,REASON_EFFECT)
		nearg=Duel.GetMatchingGroup(cm.tgfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,Duel.GetOperatedGroup())
	end
	return true
end