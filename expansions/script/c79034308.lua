--裂空の访问者
function c79034308.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_STEP_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79034308)
	e1:SetCost(c79034308.spcost)
	e1:SetTarget(c79034308.sptg)
	e1:SetOperation(c79034308.spop)
	c:RegisterEffect(e1) 
	--to tand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetCountLimit(1)
	e3:SetTarget(c79034308.thtg1)
	e3:SetOperation(c79034308.thop1)
	c:RegisterEffect(e3)  
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79034308.descon)
	e3:SetTarget(c79034308.destg)
	e3:SetOperation(c79034308.desop)
	c:RegisterEffect(e3)  
	--xyzlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c79034308.xyzlimit)
	c:RegisterEffect(e2)
end
function c79034308.xyzlimit(e,c)
	if not c then return false end
	return not (c:IsAttack(2300) and c:IsDefense(2800))
end
function c79034308.counterfilter(c)
	Duel.AddCustomActivityCounter(79034308,ACTIVITY_SPSUMMON,c79034308.counterfilter)
end
function c79034308.counterfilter(c)
	return c:GetAttack()==2300 and c:GetDefense()==2800
end
function c79034308.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(79034308,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79034308.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79034308.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:GetAttack()==2300 and c:GetDefense()==2800)
end
function c79034308.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c79034308.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
end
function c79034308.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_MZONE)
end
function c79034308.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
function c79034308.descon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	return d:IsControler(1-tp)
end
function c79034308.xyzfilter(c,sg)
	return c:IsXyzSummonable(sg,1,1)
end
function c79034308.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Group.FromCards(e:GetHandler())
	local xyzg=Duel.GetMatchingGroup(c79034308.xyzfilter,tp,LOCATION_EXTRA,0,nil,sg)
	if chk==0 then return xyzg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79034308.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.FromCards(e:GetHandler())
	local xyzg=Duel.GetMatchingGroup(c79034308.xyzfilter,tp,LOCATION_EXTRA,0,nil,sg)
	if xyzg:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
	Duel.XyzSummon(tp,xyz,sg)
	end
end













