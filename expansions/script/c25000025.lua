--黑暗的支配者
if not pcall(function() require("expansions/script/c25000024") end) then require("script/c25000024") end
local m,cm=rscf.DefineCard(25000025)
function cm.initial_effect(c)
	local e1=aux.AddRitualProcGreater2Code2(c,25000031,25000032,nil,nil,aux.TRUE)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetOperation(cm.ritop(e1:GetOperation()))
	local e2=rsef.I(c,{m,1},{1,m},"se,th,dish",nil,LOCATION_HAND,nil,cm.thcost,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
end
function cm.ritop(op)
	return function(e,tp,...)
		op(e,tp,...)
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc and tc:GetReasonEffect() and tc:GetReasonEffect()==e then 
			local e1=rsef.SV_CANNOT_BE_TARGET({e:GetHandler(),tc},"effect",aux.tgoval,nil,rsreset.est_pend)
		end
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(m-1)
end
function cm.thop(e,tp)
	if rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})>0 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		rsop.SelectToGrave(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,{REASON_EFFECT+REASON_DISCARD })
	end
end
