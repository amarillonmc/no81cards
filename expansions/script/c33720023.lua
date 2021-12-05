--Sepialife - Solitude in Company
--Scripted by:XGlitchy30
local id=33720023
local s=_G["c"..tostring(id)]
function s.initial_effect(c)
	--gift
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--halve stats
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetRange(LOCATION_HAND)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(s.con2)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e4:SetValue(s.defval)
	c:RegisterEffect(e4)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--check revealed status
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_HAND)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetTarget(s.checkpub)
	c:RegisterEffect(e5)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge1:SetCode(EVENT_TO_GRAVE)
	ge1:SetOperation(s.check)
	c:RegisterEffect(ge1)
	--check summons
	Duel.AddCustomActivityCounter(id,ACTIVITY_SUMMON,s.counterfilter)
    Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_FLIPSUMMON,s.counterfilter)
end
function s.check(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=false
	if c:IsPreviousLocation(LOCATION_HAND) and c:GetFlagEffect(id+100)>0 then
		p=c:GetPreviousControler()
	end
	if p then Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,re,r,rp,p,0) end
end
function s.counterfilter(c)
	return c:IsSetCard(0x144e)
end
--
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x144e)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_FLIPSUMMON)==0
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(c,1-tp,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) and c:IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		Duel.ShuffleHand(tp)
	end
end
--
function s.con2(e)
	return e:GetHandler():IsPublic()
end
function s.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end
function s.defval(e,c)
	return math.ceil(c:GetDefense()/2)
end
--
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,1-tp,false,false,POS_FACEUP)
	end
end
--
function s.checkpub(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPublic() end
	if c:IsPublic() then
		c:RegisterFlagEffect(id+100,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
	end
	return false
end