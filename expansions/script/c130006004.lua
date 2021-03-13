--瞬杀星 黑卡蒂
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130006004)
function cm.initial_effect(c)
	local e2 = rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,"sp",nil,"sp","de",LOCATION_GRAVE,cm.spcon,nil,rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e3 = rsef.RegisterClone(c,e2,"code",EVENT_SUMMON_SUCCESS)
	local e4 = rsef.RegisterClone(c,e2,"code",EVENT_CHAINING,"type",EFFECT_TYPE_QUICK_O)
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(0xff)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.matval)
	c:RegisterEffect(e1)	
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp ~= tp
end
function cm.matval(e,lc,mg,c,tp)
	return true,not mg or mg:IsContains(e:GetHandler())
end
function cm.spop(e,tp)
	local c = rscf.GetSelf(e)
	if not c or rssf.SpecialSummon(c) <=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if #g <= 0 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end 
	rshint.Select(tp,"sp")
	local lc = g:Select(tp,1,1,nil):GetFirst()
	local f = Duel.SendtoGrave 
	Duel.SendtoGrave = function(sg,reason)
		Duel.SendtoGrave = f	
		return Duel.Remove(sg,POS_FACEDOWN,reason)
	end
	Duel.LinkSummon(tp,lc,nil)
end