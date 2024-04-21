--真神 巨神兵
local m=91020011
local cm=c91020011
function c91020011.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,91020009,aux.FilterBoolFunction(Card.IsSetCard,0x9d1),1,true,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_ONFIELD,0,Duel.Release,POS_FACEUP,REASON_COST)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--immune
	local e5=Effect.CreateEffect(c) 
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cm.eval)
	c:RegisterEffect(e5)
	--destroy
	--battle
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(m,0))
	e14:SetCategory(CATEGORY_DEFCHANGE)
	e14:SetType(EFFECT_TYPE_QUICK_O)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCode(EVENT_FREE_CHAIN)
	e14:SetCountLimit(1,m*2)
	e14:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e14:SetCost(cm.bacost)
	e14:SetTarget(cm.batg)
	e14:SetOperation(cm.baop)
	c:RegisterEffect(e14)
end
function cm.cfilter1(c,tp)
	return   c:IsSetCard(0x9d1) and c:IsType(TYPE_MONSTER)
end
function cm.cfilter2(c,tp)
	return   c:IsCode(91020009)
end
function cm.fselect(g,c,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and aux.gffcheck(g,cm.cfilter1,nil,cm.cfilter2,nil)
end
function cm.con1(e,c)
if c==nil then return true end  
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
	return  g:CheckSubGroup(cm.fselect,2,2,c,tp)
end


function cm.op1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
  local fg=g:SelectSubGroup(tp,cm.fselect,false,2,2,c,tp)
  c:SetMaterial(fg)
  Duel.Release(fg,REASON_EFFECT+REASON_FUSION+REASON_MATERIAL)  
  c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end
--immune
function cm.eval(e,te)
local ph=Duel.GetCurrentPhase()
   return  (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and
	te:GetOwner()~=e:GetOwner()
end
--ruler

function c91020011.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end

--battle
function cm.rfilter(c)
	return c:IsAttribute(ATTRIBUTE_DIVINE)
end
function cm.bacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
	
end
function cm.batg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,LOCATION_MZONE)
end
function cm.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
	if g1:GetCount()>0 then
		Duel.ChangePosition(g1,0,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
	end
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if  g2:GetCount()>0 and c:IsLocation(LOCATION_MZONE) then 
		local tg,atk=g2:GetMaxGroup(Card.GetAttack)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
	Duel.BreakEffect()
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	 if  (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase() <=PHASE_BATTLE) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(cm.disable)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e2,tp)  
	end 
end
function cm.disable(e,c)
	return c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0 and c:IsType(TYPE_SPELL) and c:IsType(TYPE_TRAP)
end

