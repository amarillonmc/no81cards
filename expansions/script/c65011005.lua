--无民之国 以斯拉艾尔
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011005,"Israel")
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.FV_CANNOT_BE_TARGET(c,"effect",aux.tgoval,cm.tg,{LOCATION_ONFIELD,LOCATION_ONFIELD },cm.con)
	local e3=rsef.RegisterClone(c,e2,"val",aux.tgsval,"con",cm.con2)
	local e4=rsef.I(c,{m,0},{1,m},nil,"tg",LOCATION_SZONE,cm.setcon,nil,rstg.target(rscf.fufilter(rsisr.IsSet),nil,LOCATION_MZONE,LOCATION_MZONE),cm.limitop)
	local e5=rsef.I(c,"set",{1,m},nil,nil,LOCATION_SZONE,cm.setcon,nil,rsop.target(cm.setfilter,nil,LOCATION_DECK),cm.setop)
	if cm.switch then return end
	cm.switch = true 
	local ge1=rsef.FC({c,0},EVENT_SPSUMMON_SUCCESS)
	ge1:SetOperation(cm.regop)
end
function cm.setcon(e,tp)
	return Duel.GetFlagEffect(1-tp,m)>0
end
function cm.setfilter(c)
	return rsisr.IsSet(c) and c:IsSSetable() and c:IsType(TYPE_CONTINUOUS)
end
function cm.setop(e,tp)
	if not rscf.GetSelf(e) then return end
	rsop.SelectSSet(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.limitop(e,tp)
	local c=rscf.GetSelf(e)
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not c or not tc then return end
	local e1,e2,e3,e4=rsef.SV_CANNOT_BE_MATERIAL({c,tc},"fus,syn,xyz,link",nil,nil,{rsreset.est_pend+RESET_OPPO_TURN,Duel.GetTurnPlayer()==tp and 1 or 2})
end
function cm.regop(e,tp,eg)
	for tc in aux.Next(eg) do
		if tc:IsFaceup() and rsisr.IsSet(tc) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m,rsreset.pend,0,1)
		end
	end
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.con2(e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tg(e,c)
	return c~=e:GetHandler()
end
function cm.cfilter(c)
	return rsisr.IsSet(c) and c:IsFaceup() and c:GetOwner()~=c:GetControler()
end