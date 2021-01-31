--黄昏的狂战士
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000078)
function cm.initial_effect(c)   
	aux.AddCodeList(c,25000073)
	local e1=rsef.SV_ACTIVATE_IMMEDIATELY(c,"hand",rscon.excard2(Card.IsRace,LOCATION_MZONE,0,1,nil,RACE_MACHINE))
	local e2=rsef.ACT(c,EVENT_SPSUMMON_SUCCESS,nil,{1,m,1},nil,nil,nil,nil,rsop.target2(cm.fun,cm.filter,nil,LOCATION_MZONE,LOCATION_MZONE),cm.act)
	local e3=rsef.QO(c,nil,{m,0},nil,"th",nil,LOCATION_GRAVE,rscon.excard2(cm.rtcfilter,LOCATION_ONFIELD),rscost.cost(Card.IsAbleToDeckAsCost,"td"),rsop.target(cm.thfilter,"th",LOCATION_GRAVE,0,1,1,c),cm.thop)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,{})
end
function cm.rtcfilter(c,e,tp)
	return c:IsCode(25000073) or aux.IsCodeListed(c,25000073)
end
function cm.fun(g,e,tp,eg)
	Duel.SetTargetCard(eg)
end
function cm.filter(c,e,tp,eg)
	return eg:IsContains(c) and c:GetSummonPlayer()~=tp and Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)>0
end
function cm.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end 
function cm.act(e,tp,eg)
	local c=e:GetHandler()
	local tg=rsgf.GetTargetGroup():Filter(cm.cfilter,nil,tp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)
	if #tg<=0 or ft<=0 then return end
	local ct,og=rsgf.SelectMoveToField(tg,tp,aux.TRUE,1,ft,nil,{tp,1-tp,LOCATION_SZONE,POS_FACEUP,true})
	for tc in aux.Next(og) do
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
	if ct>0 and rscon.excard2(Card.IsCode,LOCATION_ONFIELD,0,1,nil,25000073)(e,tp) then
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_FORBIDDEN)
		e1:SetTargetRange(0,0x7f)
		e1:SetTarget(cm.bantg)
		e1:SetLabelObject(og)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.bantg(e,c)
	local og=e:GetLabelObject()
	return og:IsExists(Card.IsCode,1,nil,c:GetCode())
end
