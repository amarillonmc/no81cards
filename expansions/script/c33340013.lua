--时境断裂
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33340013
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	e1:RegisterSolve(cm.con,nil,nil,cm.op)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
end
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function cm.con(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end 
function cm.op(e,tp)
	local c=e:GetHandler()
	local e1=rsef.FC({c,tp},EVENT_SPSUMMON_SUCCESS,nil,nil,nil,nil,nil,cm.spop,rsreset.pend)
	local e2=rsef.FV_LIMIT_PLAYER({c,tp},"sp",nil,cm.tg,{0,1},nil,rsreset.pend)
	e2:SetLabelObject(e1)
end
function cm.spop(e,tp,eg)
	local loc=0
	local loclist=LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_SZONE
	for tc in aux.Next(eg) do
		local loc2=tc:GetPreviousLocation()
		if tc:GetSummonPlayer()~=tp and loc2&loclist~=0 then
			loc=loc|loc2
		end
	end
	e:SetLabel(loc)
end
function cm.tg(e,c)
	return c:IsLocation(e:GetLabelObject():GetLabel())
end