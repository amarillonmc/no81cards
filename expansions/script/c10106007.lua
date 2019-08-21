--梦魇魔·惧魔
function c10106007.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--summon cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCost(c10106007.scost)
	e1:SetOperation(c10106007.scop)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10106007,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c10106007.thtg)
	e3:SetOperation(c10106007.thop)
	c:RegisterEffect(e3) 
	--extra summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(c10106007.sumop)
	c:RegisterEffect(e4)   
end
function c10106007.scost(e,c,tp)
	return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
end
function c10106007.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c10106007.sumop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c10106007.atktg)
	e1:SetValue(c10106007.atkval)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetValue(c10106007.defval)
	Duel.RegisterEffect(e2,tp)
end
function c10106007.atktg(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL 
end
function c10106007.atkval(e,c)
	return c:GetAttack()/2
end
function c10106007.defval(e,c)
	return c:GetDefense()/2
end
function c10106007.thfilter(c)
	return c:IsSetCard(0x3338) and c:IsAbleToHand() and c:IsFaceup()
end
function c10106007.acfilter(c,tp)
	return c:IsSetCard(0x3338) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:GetActivateEffect():IsActivatable(tp,true)
end
function c10106007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10106007.acfilter,tp,0x11,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_MZONE)
end
function c10106007.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10106007.acfilter),tp,0x11,0,1,1,nil,tp):GetFirst()
	if tc then
	   if not Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
	   local te=tc:GetActivateEffect()
	   local tep=tc:GetControler()
	   local cost=te:GetCost()
	   if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	   local rg=Duel.GetMatchingGroup(c10106007.thfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	   if rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10106007,1)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		  local rg2=rg:Select(tp,1,1,nil)
		  Duel.HintSelection(rg2)
		  Duel.SendtoHand(rg2,nil,REASON_EFFECT)
		end
	end
end
