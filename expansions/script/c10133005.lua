--狂猎大狼
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local s,id,o = GetID()
function s.initial_effect(c)
	aux.EnableChangeCode(c,10133001,LOCATION_MZONE)
	aux.AddCodeList(c,10133001)
	local e1 = rscf.AddSpecialSummonProcdure(c,LOCATION_HAND,s.sprcon)
	local e2 = rsef.I(c,"sp",{1,id},"des,sp,lg","tg",LOCATION_MZONE,nil,nil,
		rstg.target(s.dfilter,"des",LOCATION_ONFIELD,LOCATION_ONFIELD),s.desop)
end
function s.sprfilter(c)
	return (c:IsCode(10133001) or (c:IsType(TYPE_FUSION) and c:IsSetCard(0x3334))) and c:IsFaceup()
end
function s.sprcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.sprfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function s.dfilter(c,e,tp)
	return Duel.GetMZoneCount(tp,c,tp) > 0 and (c:IsControler(tp) or Duel.IsExistingMatchingCard(s.sprfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()))
end
function s.spfilter(c,e,tp)
	return rscf.spfilter()(c,e,tp) and c:IsLevel(4)
end
function s.desop(e,tp)
	local tc = rscf.GetTargetCard()
	if tc and Duel.Destroy(tc,REASON_EFFECT) > 0 then
		rsop.SelectExPara("sp",true)
		rsop.SelectOperate("sp",tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,{},e,tp)
	end
end