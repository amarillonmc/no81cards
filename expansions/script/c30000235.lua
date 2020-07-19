--天罚机 德拉格尼克
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(30000235)
function cm.initial_effect(c)
	rscf.SetSummonCondition(c,false,aux.FALSE)
	local e1=rsef.I(c,{m,0},nil,"dr","ptg",LOCATION_HAND,nil,rscost.cost(Card.IsAbleToDeckAsCost,"td"),rsop.target(1,"dr"),cm.drop)
	local e2=rsef.FTO(c,m,{m,1},nil,"sp,rm","de",LOCATION_DECK,cm.spcon,cm.spcost,rsop.target(cm.spfilter,"sp"),cm.spop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(0xff)
	e3:SetOperation(cm.chainop)
	c:RegisterEffect(e3)
	local e4=rsef.SV_IMMUNE_EFFECT(c,rsval.imes)
	local e5=rsef.SV_UPDATE(c,"atk",cm.atkval)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EXTRA_ATTACK)
	e6:SetValue(cm.acval)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_ATTACK)
	e7:SetCondition(cm.cacon)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_ATTACK_COST)
	e8:SetCost(cm.atcost)
	e8:SetOperation(cm.atop)
	c:RegisterEffect(e8)
	if cm.gf then return end
	cm.gf=true  
	local ge1=rsef.FC({c,0},EVENT_DESTROYED)
	ge1:SetOperation(cm.regop)
	local ge2=rsef.RegisterClone({c,0},ge1,"code",EVENT_REMOVE)
	local ge3=rsef.FC({c,0},EVENT_CHAIN_NEGATED)
	ge3:SetOperation(cm.regop2)
	local ge4=rsef.RegisterClone({c,0},ge3,"code",EVENT_CHAIN_DISABLED)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()==e:GetHandler() then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.drop(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,1,REASON_EFFECT)
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
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m+100)==0 end
	Duel.RegisterFlagEffect(tp,m+100,RESET_CHAIN,0,1)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.spop(e,tp,eg)
	local c=rscf.GetSelf(e)
	if not c or rssf.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)<=0 then return end
	c:CompleteProcedure()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,c)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.atcost(e,c,tp)
	return Duel.CheckLPCost(1-tp,1000)
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(1-tp,1000)
end
function cm.atkval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*1000
end
function cm.acval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)-1
end
function cm.cacon(e,tp)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)==0
end