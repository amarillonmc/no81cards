--源于黑影 重生
local s,id,o=GetID()
if not CATEGORY_SSET then CATEGORY_SSET=0 end
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SSET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+65820000)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_HAND+LOCATION_SZONE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(s.damcon1)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
end


function s.cfilter1(c,tp)
	return c:IsSetCard(0x3a32)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil,tp) and ep==tp
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.thfilter(c,e)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x3a32) and c:IsSSetable() and not c:IsCode(id)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end

function s.thfilter1(c,e)
	return c:IsCode(id) and c:IsFaceupEx()
end
function s.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) and c:IsFaceupEx() and Duel.GetFlagEffect(tp,id)==0 and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)<=0 and Duel.GetLP(1-tp)~=0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.RegisterFlagEffect(tp,id,0,0,1)
		Duel.Hint(HINT_CARD,0,id)
		Duel.SetLP(tp,4000)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_EFFECT,tp,tp,4000)
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		if not Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_SZONE+LOCATION_HAND,0,1,c) then return end
		local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_SZONE+LOCATION_HAND,0,1,1,c)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
