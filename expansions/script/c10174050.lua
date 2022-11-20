--骑乘决斗，加速！
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174050)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,2},"sp",nil,nil,nil,rsop.target(rscf.spfilter2(Card.IsType,TYPE_SYNCHRO),"sp",LOCATION_EXTRA),cm.act)
end
function cm.act(e,tp)
	local c=e:GetHandler()
	local _,sg=rsop.SelectSpecialSummon(tp,rscf.spfilter2(Card.IsType,TYPE_SYNCHRO),tp,LOCATION_EXTRA,0,1,1,nil,{},e,tp)
	if #sg>0 then
		local tc=sg:GetFirst()
		rscf.QuickBuff({c,tc,true},"atkf,deff",0,"dis,dise",true,"ress~,resns~",true,"fus~,xyz~,link~",true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
		e1:SetTarget(cm.synlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function cm.synlimit(e,c)
	return c:IsType(TYPE_SYNCHRO)
end