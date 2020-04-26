--暗黑行星 斯菲亚之祖
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000011)
if rsgs then return end
rsgs=cm 
function rsgs.isfus(c)
	return c:IsSetCard(0xaf2) and c:IsType(TYPE_FUSION)
end
function rsgs.isfusf(c)
	return c:IsSetCard(0xaf2) and c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function rsgs.FusTypeFun(c,code,ctype)
	local e1=rsef.I(c,{code,0},{1,code+100},nil,"tg",LOCATION_MZONE,nil,rscost.cost(cm.ctypecfilter,"td",rsloc.hg),rstg.target(cm.ctypefilter,nil,LOCATION_MZONE,LOCATION_MZONE),cm.ctypeop)   
	e1:SetLabel(ctype)
	e1:SetValue(code)
	return e1
end
function cm.ctypecfilter(c)
	return (c:IsSetCard(0xaf2) or c:IsLevel(1)) and c:IsAbleToDeckAsCost()
end
function cm.ctypefilter(c,e)
	return c:IsFaceup() and not c:IsType(e:GetLabel())
end
function cm.ctypeop(e,tp)
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	tc:RegisterFlagEffect(m,rsreset.est_pend,EFFECT_FLAG_CLIENT_HINT,1,e:GetLabel(),aux.Stringid(e:GetValue(),0))
end
function rsgs.FusProcFun(c,code,ctype,cate,flag,tg,op)
	local e1=rssf.SetSummonCondition(c,false,rsval.spconfe)
	aux.AddFusionProcCodeFun(c,25000014,cm.fumatfilter(ctype),1,true,false)
	local e2=aux.AddContactFusionProcedure(c,cm.fumatfilter2,LOCATION_MZONE,LOCATION_MZONE,Duel.SendtoGrave,REASON_COST+REASON_MATERIAL+REASON_FUSION)
	local e3=rsef.SV_INDESTRUCTABLE(c,"effect",aux.indoval)
	local e4=rsef.STO(c,EVENT_LEAVE_FIELD,{code,1},nil,cate,flag,cm.fusleavecon,nil,tg,op)
	return e1,e2,e3,e4
end
function cm.fumatfilter(ctype)
	return function(c,fc)
		local flaglist={c:GetFlagEffectLabel(m)}
		return (c:IsFusionType(ctype) or (#flaglist>0 and rsof.Table_List(flaglist,ctype)))
	end
end
function cm.fumatfilter2(c,fc)
	return c:IsAbleToGraveAsCost() and (c:IsControler(fc:GetControler()) or c:IsFaceup()) and c:IsCanBeFusionMaterial(fc)
end
function cm.fusleavecon(e,tp,eg)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end

------------------------
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m},"se,th",nil,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.act)
	local e2=rsef.I(c,{m,0},{1,m+100},"sp","tg",LOCATION_SZONE,nil,rscost.cost(Card.IsDiscardable,"dish",LOCATION_HAND),rstg.target(rscf.spfilter2(Card.IsLevel,1),"sp",LOCATION_GRAVE),cm.spop)
	local e3=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m+200},"sp","de",LOCATION_SZONE,cm.spcon2,rscost.cost(Card.IsAbleToGraveAsCost,"tg"),rsop.target(cm.spfilter2,"sp",LOCATION_EXTRA+LOCATION_GRAVE),cm.spop2)
end
function cm.thfilter(c)
	return c:IsSetCard(0xaf2) and c:IsAbleToHand()
end
function cm.act(e,tp)
	if not aux.ExceptThisCard(e) then return end
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.spop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc and aux.ExceptThisCard(e) then rssf.SpecialSummon(tc) end
end
function cm.cfilter2(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.spcon2(e,tp,eg)
	return eg:IsExists(cm.cfilter2,1,nil,1-tp)
end
function cm.spfilter2(c,e,tp)
	return rsgs.isfus(c) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and ((c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end
function cm.spop2(e,tp)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter2),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
	if #sg<=0 then return end
	local og=Group.CreateGroup()
	repeat 
		rshint.Select(tp,"sp")
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if rssf.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP,nil,{"dis,dise",true}) then
			og:AddCard(tc)
		end
		sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter2),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
	until #sg==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,1))
	Duel.SpecialSummonComplete()
	rsef.FC_PHASELEAVE({e:GetHandler(),tp},og,nil,nil,PHASE_END,"rm")
end