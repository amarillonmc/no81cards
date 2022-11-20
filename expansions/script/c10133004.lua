--饥饿狼王
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local s,id,o = GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10133001)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	aux.EnableChangeCode(c,10133001,LOCATION_EXTRA+LOCATION_MZONE)
	local e1 = rsef.SV_Card(c,"lmat~",1,"cd,uc")
	local e2 = rsef.I(c,"des",{1,id},"des,sp","tg",LOCATION_MZONE,nil,nil,
		rstg.target2(s.reg,{aux.TRUE,s.gcheck},"des",LOCATION_ONFIELD,0,1,2,c),
		s.spop)   
	--redirect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(s.recon)
	e4:SetValue(LOCATION_DECK)
	c:RegisterEffect(e4)
end
function s.recon(e,tp)
	local c = e:GetHandler()
	return c:IsPosition(POS_FACEUP) and c:IsType(rscf.extype)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsCode(10133001) or c:IsHasEffect(10133009))
end
function s.exfilter(c,g,tp)
	return rszsf.GetMZoneCount(tp, g, tp, c) > 0
end
function s.exfilter2(c,g,tp,sg)
	local splist = { 0x1, 0x2, 0x4, 0x8, 0x20, 0x40 }
	for _, zone in pairs(splist) do
		if rszsf.GetMZoneCount(tp, g, tp, c, zone)  > 0 then 
			return sg:IsExists(s.exfilter3,1,c,g,tp,zone)
		end
	end
	return false
end
function s.exfilter3(c,g,tp,zone)
	return rszsf.GetMZoneCount(tp, g, tp, c, 0x7f - zone ) > 0
end
function s.gcheck(g,e,tp)
	local sg = Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if #sg < #g then return false end
	if #g == 1 then return sg:IsExists(s.exfilter,1,nil,g,tp) end
	if #g == 2 then return sg:IsExists(s.exfilter2,1,nil,g,tp,sg) end
	return false
end
function s.gcheck2(g,e,tp)
	if #g == 1 then return g:IsExists(s.exfilter,1,nil,nil,tp) end
	if #g == 2 then return g:IsExists(s.exfilter2,1,nil,nil,tp,g) end
	return false
end
function s.reg(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#g,tp,LOCATION_EXTRA)
end
function s.spop(e,tp)
	local dg = rsgf.GetTargetGroup()
	local ct = Duel.Destroy(dg,REASON_EFFECT)
	if ct <= 0 then return end
	rsop.SelectOperate("sp",tp,{s.spfilter,s.gcheck2},tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0,ct,ct,nil,{},e,tp)
end
function s.tdop(e,tp)
	local c = rscf.GetSelf(e)
	if c then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end