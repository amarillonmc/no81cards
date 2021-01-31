--杀手比特星
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000092)
function cm.initial_effect(c)   
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lfilter,1)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"se,th","de,dsp",rscon.sumtype("link"),rscost.cost(1,"dish"),rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e2=rsef.I(c,{m,1},{1,m+100},"dr","ptg",LOCATION_MZONE,nil,rscost.cost(cm.cfilter,"td",LOCATION_GRAVE+LOCATION_REMOVED),rsop.target(1,"dr"),cm.drop)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(cm.matcon)
	e3:SetOperation(cm.matop)
	c:RegisterEffect(e3)
end
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(cm.disop)
	e4:SetReset(rsreset.est)
	rc:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	rc:RegisterEffect(e5)
	local e6=rsef.FV_LIMIT_PLAYER({c,rc},"act",cm.limitval,nil,{1,1},nil,rsreset.est)
end
function cm.limitval(e,re)
	return re:GetHandler():GetFlagEffect(m)~=0
end
function cm.cfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToDeckAsCost()
end
function cm.drop(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.lfilter(c)
	if not c:IsLinkRace(RACE_MACHINE) then return false end
	if c:IsLinkType(TYPE_LINK) and c:IsLink(1) then return false end
	return true
end
function cm.thfilter(c)
	return c:IsCode(m+1) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and not bc:IsRace(RACE_MACHINE) then
		bc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	end
end