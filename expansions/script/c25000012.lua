--灭亡的微笑
if not pcall(function() require("expansions/script/c25000011") end) then require("script/c25000011") end
local m,cm=rscf.DefineCard(25000012)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"sp,an",nil,nil,nil,rsop.target2(cm.fun,cm.spfilter,"sp",0,LOCATION_EXTRA),cm.spop)
	local e3=rsef.QO(c,nil,{m,1},nil,"dr","ptg",LOCATION_GRAVE,aux.exccon,aux.bfgcost,rsop.target(cm.drct,"dr"),cm.drop)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(aux.NOT(rscon.excard(cm.cfilter,LOCATION_MZONE,0,1)))
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:GetSummonLocation()&LOCATION_EXTRA ~=0
end
function cm.fun(g,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(tp,aux.Stringid(73988674,0),aux.Stringid(73988674,1),aux.Stringid(73988674,2),aux.Stringid(m,0))+1
	e:SetLabel(op)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCountFromEx(1-tp,1-tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,1-tp,true,false,POS_FACEUP,1-tp) 
end
function cm.spop(e,tp)
	local g1=Duel.GetMatchingGroup(cm.spfilter,tp,0,LOCATION_EXTRA,nil,e,tp)
	if #g1<=0 then return end
	Duel.ConfirmCards(tp,g1)
	local ctypelist={ TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK }
	local ctype=ctypelist[e:GetLabel()]
	if g1:IsExists(Card.IsType,1,nil,ctype) then
		rshint.Select(tp,"sp")
		local sc=g1:FilterSelect(1-tp,Card.IsType,1,1,nil,ctype):GetFirst()
		rssf.SpecialSummon(sc,0,1-tp,1-tp,true,false,POS_FACEUP,nil,{"tri",true},"td")
	end
end
function cm.drct(e,tp)
	local g=Duel.GetMatchingGroup(rsgs.isfusf,tp,rsloc.mg,0,nil)
	return g:GetClassCount(Card.GetCode)
end
function cm.drop(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(rsgs.isfusf,p,rsloc.mg,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if ct<=0 then return end
	Duel.Draw(p,ct,REASON_EFFECT)
end