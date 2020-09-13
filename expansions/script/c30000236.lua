--天罚机 德拉格尼克
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(30000236)
function cm.initial_effect(c)
	rscf.SetSummonCondition(c,false,aux.FALSE)
	local e1=rsef.FTO(c,m,{m,1},nil,"sp,rm","de,dsp",LOCATION_HAND+LOCATION_GRAVE,cm.spcon,nil,rsop.target(cm.spfilter,"sp"),cm.spop)
	local e2=rsef.SV_UPDATE(c,"atk",cm.atkval)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	e4:SetCondition(cm.aacon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE) 
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(cm.acval)
	e5:SetCondition(cm.aacon2)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetCondition(cm.cacon)
	c:RegisterEffect(e6)
	if cm.gf then return end
	cm.gf=true  
	local ge1=rsef.FC({c,0},EVENT_DESTROYED)
	ge1:SetOperation(cm.regop)
	local ge2=rsef.RegisterClone({c,0},ge1,"code",EVENT_REMOVE)
	local ge3=rsef.FC({c,0},EVENT_CHAIN_NEGATED)
	ge3:SetOperation(cm.regop2)
	local ge4=rsef.RegisterClone({c,0},ge3,"code",EVENT_CHAIN_DISABLED)
end
function cm.aacon(e)
	return e:GetHandler():GetFlagEffect(30000240)==0
end
function cm.acval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)-1
end
function cm.aacon2(e)
	return e:GetHandler():GetFlagEffect(30000240)>0
end
function cm.cacon(e,tp)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)==0 and cm.aacon2(e)
end
function cm.cfilter(c,rp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()~=rp
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		if rp==i and eg:IsExists(cm.cfilter,1,nil,rp) then
			Duel.RegisterFlagEffect(1-rp,m,rsreset.pend,0,1)
			if Duel.GetFlagEffect(1-rp,m)>=2 then 
				Duel.RaiseEvent(eg,m,re,r,rp,1-rp,ev)
			end
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
	return ep==tp and Duel.GetTurnPlayer()==tp
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.spop(e,tp,eg)
	local c=rscf.GetSelf(e)
	if not c then return end
	local res=false
	if c:IsLocation(LOCATION_GRAVE) then
		res=rssf.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP,nil,{"leave",LOCATION_REMOVED })>0 
	else
		res=rssf.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 
	end
	if not res then return end
	c:CompleteProcedure()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.atkval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*800
end