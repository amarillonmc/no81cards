--凝练灵魂的薪王
if not pcall(function() dofile("expansions/script/c10171001.lua") end) then dofile("script/c10171001.lua") end
local m,cm=rscf.DefineCard(10171024)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--aux.AddFusionProcCode2(c,10171001,10171008,true,true)
	local e1=rscf.SetSummonCondition(c,false)
	local e2=rscf.SetSpecialSummonProduce(c,LOCATION_EXTRA,cm.sprcon)
	e2:SetTarget(cm.sprtg)
	--local e3=rsef.SV_ADD(c,"code",10171001)
	aux.EnableChangeCode(c,10171001,LOCATION_MZONE)
	local e4=rsef.FC(c,EVENT_ADJUST)
	e4:SetOperation(cm.copyop)
	e4:SetRange(LOCATION_MZONE)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(m)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
	local e6=rsef.FTO(c,EVENT_PHASE+PHASE_END,{m,0},1,"td",nil,LOCATION_MZONE,nil,nil,rsop.target(Card.IsAbleToDeck,"td",LOCATION_REMOVED,0),cm.tdop)
end
function cm.resfilter(c,fc,e,tp)
	return c:IsCode(10171008) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,rsloc.hmg,0,1,c,c,fc,e,tp)
end
function cm.tdfilter(c,rc,fc,e,tp)
	return c:IsAbleToDeckAsCost() and c:IsCode(10171001) and Duel.GetLocationCountFromEx(tp,tp,rsgf.Mix2(c,rc),fc)>0
end
function cm.sprcon(e,c,tp)
	local g1=Duel.GetReleaseGroup(tp)
	return g1:IsExists(cm.resfilter,1,nil,c,e,tp)
end
function cm.gcheck(g,g1,g2)
	local tc1 = g:GetFirst()
	local tc2 = g:GetNext()
	return (g1:IsContains(tc1) and g2:IsContains(tc2)) or (g1:IsContains(tc2) and g2:IsContains(tc1))
end
function cm.sprtg(e,tp,eg)
	local c=e:GetHandler()
	local g1=Duel.GetReleaseGroup(tp):Filter(cm.resfilter,nil,c,e,tp)
	local g2=Duel.GetMatchingGroup(cm.tdfilter,tp,rsloc.hmg,0,mg,tc,c,e,tp)
	local mg = g1 + g2
	rshint.Select(tp,"res")
	local cancel=Duel.IsSummonCancelable()
	local rg = mg:SelectSubGroup(tp,cm.gcheck,cancel,2,2,g1,g2)
	if rg and #rg == 2 then
		e:SetOperation(cm.sprop(rg:GetFirst(),rg:GetNext()))
		return true
	else
		return false
	end
end
function cm.sprop(tc1,tc2)
	return function(e,tp)
		if tc1:IsCode(10171001) then 
			tc1,tc2 = tc2,tc1
		end
		Duel.Release(tc1,REASON_COST)
		if tc2:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or tc2:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc2)
		end
		Duel.SendtoDeck(tc2,nil,2,REASON_COST)
	end
end
function cm.copyop(e,tp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 or not c:IsLocation(LOCATION_MZONE) then return end
	c:RegisterFlagEffect(m,rsreset.est_d,0,1)
	c:CopyEffect(10171001,rsreset.est,1)
end
function cm.tdop(e,tp)
	rsop.SelectToDeck(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,3,nil,{})
end 