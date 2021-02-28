--机械加工 赤蚁兵
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m,cm=rscf.DefineCard(40009431)
function cm.initial_effect(c)
	local e1 = rsef.SV_CHANGE(c,"type",TYPE_NORMAL+TYPE_MONSTER)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	local e2 = rsef.I(c,"sp",{1,m},"sp",nil,LOCATION_MZONE,cm.spcon,rscost.cost(cm.resfilter,"res"),rsop.target(cm.spfilter,"sp",LOCATION_HAND),cm.spop)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp)
end
function cm.spcon(e,tp)
	local c=e:GetHandler()
	return not c:GetColumnGroup():IsExists(cm.cfilter,1,nil,tp)
end
function cm.resfilter(c,e,tp)
	return Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter(c,e,tp)
	return not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x5f1d) 
end
function cm.spfilter2(c,e,tp)
	return cm.spfilter(c,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,cm.spfilter2,tp,LOCATION_HAND,0,1,1,nil,{},e,tp)
end