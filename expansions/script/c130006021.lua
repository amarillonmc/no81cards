--反转世界的晨风
if not pcall(function() require("expansions/script/c130006013") end) then require("script/c130006013") end
local m,cm=rscf.DefineCard(130006021,"FanZhuanShiJie")
function cm.initial_effect(c)
	local e1 = rsef.A(c,nil,nil,{1,m,"o"},"sp,td",nil,nil,nil,rsop.target({cm.spfilter,"sp",LOCATION_HAND },{aux.TRUE,"td,sp",0,LOCATION_HAND }),cm.act)
	local e2 = rsef.I(c,"sset",nil,nil,nil,LOCATION_GRAVE,rscon.excard2(cm.cfilter,LOCATION_MZONE),nil,rsop.target(Card.IsSSetable,"sset"),cm.setop)
end
function cm.cfilter(c)
	return rsfz.IsSetM(c) and c:IsType(TYPE_FUSION)
end
function cm.setop(e,tp)
	local c = rscf.GetSelf(e)
	if c then
		Duel.SSet(tp,c)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp) > 0 and rsfz.IsSet(c)
end
function cm.act(e,tp)
	local g = Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,{0,tp,1-tp,false,false,POS_FACEUP },e,tp) <= 0 or #g <= 0 then return end
	Duel.ConfirmCards(tp,g)
	local g1 = g:Filter(rscf.spfilter2(),nil,e,tp)
	local g2 = g:Filter(cm.tdfilter,nil)
	if #g1 <= 0 and #g2 <= 0 then return end
	local op = rshint.SelectOption(tp,#g1>0,"sp",#g2>0,"td")
	if op == 1 then
		rsgf.SelectSpecialSummon(g1,tp,aux.TRUE,1,1,nil,{},e,tp)
	elseif op == 2 then
		rsgf.SelectToDeck(g2,tp,aux.TRUE,1,1,nil,{})
	end
end
function cm.tdfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end