--康沃森的支配者，注视于此
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm=rscf.DefineCard(30030000)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,2},nil,"cd,cn",nil,nil,rsop.target({cm.cfilter1,"",LOCATION_EXTRA },{cm.cfilter2,"",LOCATION_EXTRA }),cm.act)
end
function cm.cfilter0(c,e,tp,code)
	return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) and c:IsCode(code) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.cfilter1(c,e,tp)
	return cm.cfilter0(c,e,tp,30010000)
end
function cm.cfilter2(c,e,tp)
	return cm.cfilter0(c,e,tp,30020000)
end
function cm.act(e,tp)
	local tc1=Duel.GetFirstMatchingCard(cm.cfilter1,tp,LOCATION_EXTRA,0,nil,e,tp)
	local tc2=Duel.GetFirstMatchingCard(cm.cfilter2,tp,LOCATION_EXTRA,0,nil,e,tp)
	if not tc1 or not tc2 then return end
	Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true)  
end