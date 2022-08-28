--方舟骑士-塞雷娅
c115020.named_with_Arknight=1
function c115020.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c115020.ffilter,3,true)
	--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,115020+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c115020.hspcon)
	e0:SetOperation(c115020.hspop)
	c:RegisterEffect(e0)
	--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCost(c115020.costchk)
	e1:SetOperation(c115020.costop)
	c:RegisterEffect(e1)
	--accumulate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(0x10000000+115020)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(115020,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c115020.pencon)
	e5:SetTarget(c115020.pentg)
	e5:SetOperation(c115020.penop)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,315020)
	e6:SetCondition(c115020.spcon1)
	e6:SetTarget(c115020.sptg1)
	e6:SetOperation(c115020.spop1)
	c:RegisterEffect(e6)
end
function c115020.ffilter(c)
	return (c:IsFusionSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsFusionType(TYPE_PENDULUM)
end
function c115020.spfilter(c)
	return (c:IsFusionSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsFusionType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost() and c:IsFaceup()
end 
function c115020.spgckfil(g,sc) 
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 
end 
function c115020.hspcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c115020.spfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	return g:CheckSubGroup(c115020.spgckfil,3,3,c) and c:IsFacedown()
end
function c115020.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c115020.spfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c115020.spgckfil,false,3,3,c) 
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c115020.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,115020)
	return Duel.CheckLPCost(tp,ct*800)
end
function c115020.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,800)
end
function c115020.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c115020.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c115020.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c115020.cfilter(c,tp)
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
end
function c115020.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c115020.cfilter,1,nil,tp)
end
function c115020.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c115020.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then  
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end








