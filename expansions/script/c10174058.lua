--不死灵鹤
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174058)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,3,2)
	local e1=rsef.FV_UPDATE(c,"atk",cm.atkval,nil,{LOCATION_MZONE,0})
	local e2=rsef.I(c,{m,0},{1,m},"se,th",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
end
function cm.cfilter(c)
	return c:IsFaceup() and (c:IsLevel(3) or c:IsRank(3))
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)*300
end
function cm.thfilter(c)
	return c:IsLevel(3) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	local ct,og=rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=og:GetFirst()
	if tc and tc:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(cm.aclimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end

