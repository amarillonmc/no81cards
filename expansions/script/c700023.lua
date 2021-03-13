--UjiMatcha Flavor
if not pcall(function() require("expansions/script/c700020") end) then require("script/c700021") end
local m,cm = rscf.DefineCard(700023,"Breath")
function cm.initial_effect(c)
	local e1 = rsef.QO(c,nil,{m,0},{1,m},nil,nil,LOCATION_HAND,nil,rscost.cost(Card.IsReleasable,"res"),rsop.target(cm.setfilter,nil,LOCATION_HAND),cm.setop)
	local e2 = rsef.STO(c,EVENT_RELEASE,{m,1},{1,m+100},nil,"de",cm.mvcon,nil,nil,cm.mvop)
end
function cm.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function cm.setop(e,tp)
	local ct,og,tc=rsop.SelectSSet(tp,cm.setfilter,tp,LOCATION_HAND,0,1,1,nil,{})
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function cm.mvcon(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.mvop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	rsbh.MoveSZone(c,c,tp)
end