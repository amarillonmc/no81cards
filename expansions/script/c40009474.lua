--龙血师团-白炎血眼
if not pcall(function() require("expansions/script/c40009469") end) then require("script/c40009469") end
local m,cm = rscf.DefineCard(40009474)
function cm.initial_effect(c)
	local e1,e2,e3 = rsdb.XyzFun2(c,m,cm.con,cm.op)
	local e4 = rsef.QO(c,nil,"sp",{1,m+100},"sp","tg",LOCATION_MZONE,nil,nil,rstg.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
	local e5 = rsef.QO(c,EVENT_CHAINING,"neg",nil,"neg","dsp,dcal",LOCATION_MZONE,rscon.negcon(cm.negfilter),rscost.rmxyz(1),rstg.negtg(),rsop.negop())
end
function cm.matfilter(c)
	return c:IsCanOverlay() and c:IsType(TYPE_XYZ) and c:IsRankAbove(1) and c:FieldPosCheck() and not c:IsCode(m)
end
function cm.gcheck(g,tp,c)
	return g:GetClassCount(Card.GetRank) == #g and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function cm.con(e,c,tp)
	local g=Duel.GetMatchingGroup(cm.matfilter,tp,rsloc.mg,0,nil)
	return g:CheckSubGroup(cm.gcheck,3,3,tp,c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.matfilter,tp,rsloc.mg,0,nil)
	rshint.Select(tp,HINTMSG_SELF)
	local matg=g:SelectSubGroup(tp,cm.gcheck,false,3,3,tp,c)
	local og = Group.CreateGroup()
	for tc in aux.Next(matg) do
		og:Merge(tc:GetOverlayGroup())
	end
	if #og>0 then
		Duel.SendtoGrave(og,REASON_RULE)
	end
	Duel.Overlay(c,matg)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x3f1b) and rscf.spfilter2()(c,e,tp)
end
function cm.spop(e,tp)
	local c,tc = rscf.GetSelf(e),rscf.GetTargetCard()
	if not tc or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	local cg = Duel.GetMatchingGroup(cm.ofilter,tp,0,LOCATION_ONFIELD,nil)
	if c and c:GetOverlayCount()>0 and #cg>0 and not tc:IsImmuneToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		rshint.Select(tp,HINTMSG_XMATERIAL)
		local mg = cg:Select(tp,1,1,nil)
		rshint.Select(tp,HINTMSG_XMATERIAL)
		local mg2 = c:GetOverlayGroup():Select(tp,1,1,nil)
		Duel.Overlay(tc,mg+mg2)
	end
end
function cm.negfilter(e,tp,re,rp,tg)
	return #tg>0
end