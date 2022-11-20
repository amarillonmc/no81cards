--规则调停
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10174032
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"dis,des","tg",nil,nil,rstg.target2(cm.fun,cm.disfilter,"des",LOCATION_MZONE,LOCATION_MZONE,5),cm.activate)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end
function cm.disfilter(c)
	return c:IsType(TYPE_EFFECT) and aux.disfilter1(c)
end
function cm.activate(c,e)
	local g=rsgf.GetTargetGroup(cm.disfilter)
	local og=Group.CreateGroup()
	if #g>0 then
		for tc in aux.Next(g) do
			local e1,e2=rsef.SV_LIMIT({e:GetHandler(),tc},"dis,dise",nil,nil,rsreset.est)
			Duel.AdjustInstantly()
			if tc:IsDisabled() then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)  
				og:AddCard(tc)
			end
		end
		Duel.Destroy(og,REASON_EFFECT)
	end
end
