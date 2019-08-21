--深层空想 失落雨林
local m=10122014
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsul.GraveDestroyActivateEffect(c,m)
	local e3=rsef.FTO(c,EVENT_CHAIN_SOLVING,{m,0},nil,"tk,sp","de",LOCATION_FZONE,cm.con,nil,rsul.TokenTg(1),rsul.TokenOp(rsul.advtkop)) 
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
