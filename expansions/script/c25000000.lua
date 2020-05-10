--根源性破灭招来体
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000000)
if rszg then return end
rszg=cm 
function rszg.XyzFun(c,code,rk,limit)
	local e1=rsef.ACT(c,nil,nil,limit,"sp",nil,nil,nil,rsop.target({cm.xyzfilter(rk),"sp",LOCATION_EXTRA},{rszg.matfilter,nil,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED }),cm.act(code,rk))
	return e1
end
function cm.xyzfilter(rk)
	return function(c,e,tp)
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsRank(rk) and c:IsSetCard(0xaf1)
	end
end
function rszg.matfilter(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsSetCard(0xaf1) and c:IsCanOverlay()
end
function cm.act(code,rk)
	return function(e,tp)
		local c=aux.ExceptThisCard(e)
		if not c then return end
		c:RegisterFlagEffect(code,rsreset.est_pend,0,1)
		local ct,og,tc=rsop.SelectSpecialSummon(tp,cm.xyzfilter(rk),tp,LOCATION_EXTRA,0,1,1,nil,{SUMMON_TYPE_XYZ},e,tp)
		if ct<=0 then return end
		tc:CompleteProcedure()
		rszg.OverlayFun(tc)
	end
end
function rszg.OverlayFun(tc)
	rsop.SelectSolve(HINTMSG_XMATERIAL,tc:GetControler(),rszg.matfilter,tc:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,{cm.matfun,tc})
end
function cm.matfun(g,tc)
	Duel.Overlay(tc,g)
end
function rszg.ToGraveFun(c)
	--local e1=rsef.SV_REDIRECT(c,"tg",LOCATION_REMOVED,cm.tgcon,nil,"sa,ii")
	--e1:SetRange(0xff)
	--return e1
end
function cm.tgcon(e)
	return not e:GetHandler():IsLocation(LOCATION_OVERLAY)
end
function rszg.SpSummonFun(c,code,event,con)
	local e1=rsef.FTO(c,event,{m,2},{1,code},"sp","de",LOCATION_HAND,con,nil,rsop.target(rscf.spfilter2(),"sp"),cm.handspop)
	return e1
end
function cm.handspop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then rssf.SpecialSummon(c) end
end
function rszg.SSSucessFun(c,code,cate,flag,tg,op)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{code,0},{1,code+100},cate,flag,nil,nil,tg,op)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,3},{1,code+100},"sp","de,dsp",nil,nil,rsop.target(cm.ssspfilter,"sp",LOCATION_EXTRA),cm.ssspop)
	return e1,e2
end
function cm.ssspfilter(c,e,tp)
	return c:IsRank(4) and c:IsType(TYPE_XYZ) and c:IsSetCard(0xaf1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.IsExistingMatchingCard(cm.ssmatfilter,tp,LOCATION_MZONE,0,1,nil,c,e,tp)
end
function cm.ssmatfilter(c,sc,e,tp)
	return c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeXyzMaterial(sc) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cm.ssspop(e,tp)
	rshint.Select(tp,"sp")
	local sc=Duel.SelectMatchingCard(tp,cm.ssspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if not sc then return end
	rshint.Select(tp,HINTMSG_XMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,cm.ssmatfilter,tp,LOCATION_MZONE,0,1,1,nil,sc,e,tp):GetFirst()
	local mg=tc:GetOverlayGroup()
	if #mg>0 then
		Duel.Overlay(sc,mg)
	end
	sc:SetMaterial(Group.FromCards(tc))
	Duel.Overlay(sc,Group.FromCards(tc))
	Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure()
end
function rszg.XyzSumFun(c,code,lv,spfilter)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,lv,3)
	if spfilter then
		local e1=rsef.STO(c,EVENT_LEAVE_FIELD,{m,2},{1,code+300},"sp","de,dsp",cm.xyzleavecon,nil,rsop.target({cm.xyzleavefilter(spfilter),"sp",LOCATION_EXTRA },{Card.IsCanOverlay,nil}),cm.xyzleaveop(spfilter))
		return e1
	end
end
function cm.xyzleavecon(e,tp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_BATTLE+REASON_EFFECT) 
end 
function cm.xyzleavefilter(spfilter) 
	return function(c,e,tp)
		if not c:IsType(TYPE_XYZ) then return false end
		return ((type(spfilter)=="number" and c:IsCode(spfilter)) or (type(spfilter)~="number"and spfilter(c,e,tp))) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
	end
end
function cm.xyzleaveop(spfilter)
	return function(e,tp)
		local c=aux.ExceptThisCard(e)
		local ct,og,tc=rsop.SelectSpecialSummon(tp,cm.xyzleavefilter(spfilter),tp,LOCATION_EXTRA,0,1,1,nil,{ SUMMON_TYPE_XYZ },e,tp)
		if ct>0 then
			tc:CompleteProcedure()
			if c and c:IsCanOverlay() then
				Duel.Overlay(tc,Group.FromCards(c))
			end
		end
	end
end
-------------------
function cm.initial_effect(c)
	local e1=rszg.XyzFun(c,m,4,{1,m})
	local e2=rsef.I(c,{m,0},{1,m+100},"se,th",nil,LOCATION_FZONE,nil,rscost.cost(Card.IsDiscardable,"dish",LOCATION_HAND),rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e3=rsef.I(c,{m,1},{1,m+100},"td",nil,LOCATION_FZONE,nil,rscost.cost(Card.IsDiscardable,"dish",LOCATION_HAND),rsop.target(cm.tdfilter,"td",LOCATION_REMOVED),cm.tdop)
	local e4=rsef.FV_REDIRECT(c,"tg",LOCATION_REMOVED,nil,{0xff,0xff})
	local e5=rszg.ToGraveFun(c)
	local e6=rsef.STO(c,EVENT_LEAVE_FIELD,{m,2},nil,"sp",nil,cm.flspcon,nil,rsop.target(cm.flspfilter,"sp",LOCATION_REMOVED),cm.flspop)
end
function cm.thfilter(c)
	return c:IsSetCard(0xaf1) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	if not aux.ExceptThisCard(e) then return end
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.tdfilter(c)
	return c:IsSetCard(0xaf1) and c:IsAbleToDeck() and c:IsFaceup()
end
function cm.tdop(e,tp)
	if not aux.ExceptThisCard(e) then return end
	rsop.SelectToDeck(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil,{})
end
function cm.flspcon(e,tp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function cm.flspfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xaf1) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.flspop(e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	rsop.SelectSpecialSummon(tp,cm.flspfilter,tp,LOCATION_REMOVED,0,1,math.min(ft,99),nil,{},e,tp)
end 