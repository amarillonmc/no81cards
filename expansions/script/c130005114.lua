--堕龙唤士-希梅亚 
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005114,"DragonCaller")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lfilter,2)
	c:SetSPSummonOnce(m)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"sp,se,th","de",rscon.sumtype("link"),nil,rsop.target2(cm.fun,cm.tfilter,"th",rsloc.dg),cm.thop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(cm.valcheck)
	e4:SetLabel(0)
	c:RegisterEffect(e4)
	local e2=rsef.FV_LIMIT_PLAYER(c,"sp",nil,cm.splimit,{0,1})
	e2:SetLabelObject(e4)
	local e3=rsef.QO(c,nil,{m,1},nil,"sp",nil,LOCATION_EXTRA,nil,rscost.cost(Card.IsAbleToRemoveAsCost,"rm"),cm.syntg,cm.synop)
	local e5=rsef.RegisterClone(c,e3,"desc",{m,2},"tg",cm.xyztg,"op",cm.xyzop)
	local e6=rsef.RegisterClone(c,e3,"desc",{m,3},"tg",cm.linktg,"op",cm.linkop)
end
function cm.matfilter(c)
	return c:IsFaceup() and rsdc.IsSet(c)
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,e:GetHandler(),nil,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp)
	local matg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,aux.ExceptThisCard(e),nil,matg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,0,nil) 
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,e:GetHandler(),g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xyz=Duel.SelectMatchingCard(tp,Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,1,aux.ExceptThisCard(e),g,1,#g):GetFirst()
	if xyz then
	   Duel.XyzSummon(tp,xyz,g1,#g)
	end
end
function cm.linktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,0,nil) 
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,e:GetHandler(),g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local linkc=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,aux.ExceptThisCard(e),g):GetFirst()
	if linkc then
	   Duel.LinkSummon(tp,linkc,g)
	end
end
function cm.splimit(e,c)
	return c:IsLocation(e:GetLabelObject():GetLabel())
end
function cm.valcheck(e,c)
	local mat=c:GetMaterial()
	local loc=0
	for tc in aux.Next(mat) do 
		if tc:IsSummonType(SUMMON_TYPE_SPECIAL) or tc:IsSummonType(SUMMON_TYPE_NORMAL) then
			loc=loc|tc:GetSummonLocation()
		end 
	end
	e:SetLabel(loc)
end
function cm.lfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and rsdc.IsLinkSet(c)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,rsloc.dg)
end
function cm.tfilter(c,e,tp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if not rsdc.IsSetM(c) then return false end
	return (zone>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)) or c:IsAbleToHand()
end
function cm.thop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	rsop.SelectSolve(HINTMSG_SELF,tp,aux.NecroValleyFilter(cm.tfilter),tp,rsloc.dg,0,1,1,nil,cm.solve,e,tp)
end
function cm.solve(g,e,tp)
	local tc=g:GetFirst()
	local zone=e:GetHandler():GetLinkedZone(tp) 
	local b1=tc:IsAbleToHand()
	local b2=zone>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
	local op=rsop.SelectOption(tp,b1,1190,b2,1152)
	if op==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	return true
end