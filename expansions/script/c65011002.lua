--以斯拉的复仇 天帝之怒
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011002,"Israel")
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},nil,"tg",nil,nil,rstg.target(rscf.fufilter(rsisr.IsSet),nil,LOCATION_MZONE,LOCATION_MZONE),cm.act)
	local e2=rsef.FTO(c,EVENT_PHASE+PHASE_BATTLE_START,nil,{1,m+100},"th",nil,LOCATION_SZONE,rscon.turno,nil,rsop.target(cm.thfilter,"th",LOCATION_MZONE,LOCATION_MZONE),cm.thop)
	local e5=rsef.RegisterClone(c,e2,"code",EVENT_PHASE+PHASE_END)
	local e3=rsef.FV_LIMIT_PLAYER(c,"act",cm.actlimit,nil,{1,0},cm.acon)
	local e4=rsef.FV_LIMIT_PLAYER(c,"act",cm.actlimit,nil,{0,1},cm.acon2)
end
function cm.actlimit(e,re)
	return re:GetHandler():IsLocation(LOCATION_MZONE)
end
function cm.acon(e,tp)
	return rscon.excard2(rsisr.IsSet,LOCATION_MZONE)(e,tp)
end
function cm.acon2(e,tp)
	return rscon.excard2(rsisr.IsSet,0,LOCATION_MZONE)(e,tp)
end
function cm.thfilter(c)
	return Duel.IsPlayerCanSendtoHand(c:GetControler(),c) and c:IsFaceup() and not rsisr.IsSet(c)
end
function cm.thop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	for p=0,1 do 
		local g=Duel.GetMatchingGroup(cm.thfilter,p,LOCATION_MZONE,0,nil)
		local tg=g:GetMaxGroup(Card.GetAttack)
		if #tg>0 then
			rsgf.SelectToHand(tg,p,aux.TRUE,1,1,nil,{ nil,REASON_RULE })
		end
	end
end
function cm.act(e,tp)
	local c=rscf.GetSelf(e)
	local tc=rscf.GetTargetCard()
	if not c or not tc then return end
	local e1,e2=rsef.SV_LIMIT({c,tc},"ress,resns",nil,nil,rsreset.est)
	local e3,e4,e5,e6=rsef.SV_CANNOT_BE_MATERIAL({c,tc},"fus,syn,xyz,link",nil,nil,rsreset.est)
end
