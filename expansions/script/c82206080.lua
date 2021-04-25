local m=82206080
local cm=_G["c"..m]
cm.name="我太帅了"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c) 
	--debuff  
	local e0=Effect.CreateEffect(c)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(cm.plimit)  
	c:RegisterEffect(e0) 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)  
	e2:SetRange(LOCATION_PZONE)  
	e2:SetTarget(cm.rmtarget)  
	e2:SetTargetRange(0xff,0xff)  
	e2:SetValue(LOCATION_REMOVED)  
	c:RegisterEffect(e2)  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(m)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e3:SetTargetRange(0xff,0xff)  
	e3:SetTarget(cm.checktg)  
	c:RegisterEffect(e3) 
	--double battle damage
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))	
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetRange(LOCATION_PZONE)  
	e4:SetCountLimit(1,m)  
	e4:SetCost(cm.cost)  
	e4:SetCondition(cm.damcon)
	e4:SetOperation(cm.damop)  
	c:RegisterEffect(e4)
	--atk up
	local e5=Effect.CreateEffect(c)  
	e5:SetCategory(CATEGORY_ATKCHANGE)  
	e5:SetType(EFFECT_TYPE_QUICK_O)  
	e5:SetRange(LOCATION_MZONE)  
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.atkcon)  
	e5:SetCost(cm.cost)  
	e5:SetOperation(cm.atkop)  
	c:RegisterEffect(e5)   
	--spsummon  
	local e6=Effect.CreateEffect(c)  
	e6:SetDescription(aux.Stringid(m,2))  
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e6:SetCode(EVENT_REMOVE)  
	e6:SetProperty(EFFECT_FLAG_DELAY)  
	e6:SetCountLimit(1,82216080)  
	e6:SetCost(cm.cost)
	e6:SetTarget(cm.sptg)  
	e6:SetOperation(cm.spop)  
	c:RegisterEffect(e6)	
end
function cm.plimit(e,se,sp,st)  
	return bit.band(st,SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=800
	if Duel.IsPlayerAffectedByEffect(tp,82206075) then lp=400 end
	if chk==0 then return Duel.CheckLPCost(tp,lp) end  
	Duel.PayLPCost(tp,lp)  
end  
function cm.splimit(e,c,tp,sumtype,sumpos,targetp)   
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM or not c:IsAttribute(ATTRIBUTE_DARK)
end  
function cm.rmtarget(e,c)  
	return not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP)  and c:GetOwner()==e:GetHandlerPlayer()  
end  
function cm.checktg(e,c)  
	return not c:IsPublic()  
end  
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsAbleToEnterBP()  
end  
function cm.damop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CHANGE_DAMAGE)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetTargetRange(0,1)  
	e2:SetValue(cm.val)  
	e2:SetReset(RESET_PHASE+PHASE_BATTLE)  
	Duel.RegisterEffect(e2,tp)  
end  
function cm.val(e,re,dam,r,rp,rc)  
	if bit.band(r,REASON_BATTLE)~=0 then  
		return dam*2  
	else return dam end  
end  
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()  
	return bc and bc:GetAttack()>0  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()  
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then  
		local atk=bc:GetAttack()
		atk=atk/2
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		e1:SetValue(atk)  
		c:RegisterEffect(e1)  
	end  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end  

