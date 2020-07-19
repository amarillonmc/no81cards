--天罚机 德拉格尼克
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(30000236)
function cm.initial_effect(c)
	rscf.SetSummonCondition(c,false,aux.FALSE)
	local e1=rsef.FTO(c,m,{m,1},nil,"sp,rm","de",LOCATION_HAND+LOCATION_GRAVE,cm.spcon,nil,rsop.target(cm.spfilter,"sp"),cm.spop)
	local e2=rsef.SV_UPDATE(c,"atk",cm.atkval)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	if cm.gf then return end
	cm.gf=true  
	local ge1=rsef.FC({c,0},EVENT_DESTROYED)
	ge1:SetOperation(cm.regop)
	local ge2=rsef.RegisterClone({c,0},ge1,"code",EVENT_REMOVE)
	local ge3=rsef.FC({c,0},EVENT_CHAIN_NEGATED)
	ge3:SetOperation(cm.regop2)
	local ge4=rsef.RegisterClone({c,0},ge3,"code",EVENT_CHAIN_DISABLED)
end
function cm.cfilter(c,rp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()~=rp
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		if rp==i and eg:IsExists(cm.cfilter,1,nil,rp) then
			Duel.RegisterFlagEffect(1-rp,m,rsreset.pend,0,1)
		end
	end
	for i=0,1 do
		if Duel.GetFlagEffect(i,m)>=2 then
			Duel.RaiseEvent(eg,m,re,r,rp,ep,ev)
		end
	end
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,m,rsreset.pend,0,1)
	if Duel.GetFlagEffect(ep,m)>=2 then
		Duel.RaiseEvent(re:GetHandler(),m,re,r,1-ep,ep,ev)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.GetTurnPlayer()==tp
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.spop(e,tp,eg)
	local c=rscf.GetSelf(e)
	if not c or rssf.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)<=0 then return end
	c:CompleteProcedure()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.atkval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*800
end