--深层空想 恶魂之冢
local m=10122013
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsul.GraveDestroyActivateEffect(c,m)
	local e3=rsef.FTO(c,EVENT_SUMMON_SUCCESS,{m,0},nil,"tk,sp","de",LOCATION_FZONE,cm.con,nil,rsul.TokenTg(1),rsul.TokenOp(rsul.advtkop))
	local e4=rsef.RegisterClone(c,e3,"code",EVENT_SPSUMMON_SUCCESS)
end
function cm.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end

