--郊外荒野
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local s,id,o = GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10133001)
	local e1 = rsef.A(c)
	local e2 = rsef.I(c,{id,0},{1,id},"sp,lg",nil,LOCATION_FZONE,nil,
		rscost.paylp(800),rsop.target(s.spfilter,"dum",
		rsloc.hg,LOCATION_GRAVE),s.spop)
	local e3 = rsef.STO(c,EVENT_DESTROYED,"sset",{1,id+100},"sset","de",s.setcon,
		nil,rsop.target(s.setfilter,"sset",LOCATION_DECK),s.setop)
	local e4 = rsef.FTO(c,EVENT_DESTROYED,"sset",{1,id+100},"sset","de,dsp",
		LOCATION_FZONE,s.setcon2,nil,
		rsop.target(s.setfilter,"sset",LOCATION_DECK),s.setop)
end
function s.xfilter(c)
	return c:IsFaceup() and c:IsCode(10133001) and c:IsType(TYPE_XYZ)
end 
function s.spfilter(c,e,tp)
	if not c:IsLevelAbove(1) or not c:IsType(TYPE_EFFECT) then return false end
	local b1 = rscf.spfilter2()(c,e,tp)
	local b2 = c:IsCanOverlay() and Duel.IsExistingMatchingCard(s.xfilter,tp,LOCATION_MZONE,0,1,nil)
	return b1 or b2
end
function s.spop(e,tp)
	local og,tc = rsop.SelectCards("dum",tp,aux.NecroValleyFilter(s.spfilter),tp,rsloc.hg,LOCATION_GRAVE,1,1,nil,e,tp)
	if not tc then return end
	local b1 = rscf.spfilter2()(tc,e,tp)
	local b2 = tc:IsCanOverlay() and Duel.IsExistingMatchingCard(s.xfilter,tp,LOCATION_MZONE,0,1,nil)
	local op = rshint.SelectOption(tp,b1,"sp",b2,{id,1})
	if op == 1 then
		rssf.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,nil,{"lv",4,"dis",true,"dise",true})
	else
		rshint.Select(tp,{id,2})
		local tg = Duel.SelectMatchingCard(tp,s.xfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(tg)
		Duel.Overlay(tg:GetFirst(),Group.FromCards(tc))
	end
end

function s.setcon(e,tp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.setcon2(e,tp,eg)
	return eg:IsExists(Card.IsReason,1,nil,REASON_EFFECT)
end
function s.setfilter(c)
	return aux.IsCodeListed(c,10133001) and not c:IsCode(id) and c:IsSSetable()
end
function s.setop(e,tp)
	rsop.SelectOperate("sset",tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end