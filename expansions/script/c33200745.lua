--双弹的水将 克雷塔斯
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x32a)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(s.spcon0)
	e0:SetOperation(s.spop0)
	c:RegisterEffect(e0)   
	--double attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+1)
	e1:SetCost(s.cost)  
	e1:SetOperation(s.daop)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+2)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end

--e0
function s.spf0(c,ec,ft,tp)
	return c:IsSetCard(0xc32a) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.spf1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE,0,1,ec,c,ft)
end
function s.spf1(c,rc,ft)
	if ft>0 or rc:IsLocation(LOCATION_MZONE) then
		return c:IsSetCard(0xc32a) and c:IsAbleToRemoveAsCost() and not c:IsLocation(rc:GetLocation())
	else
		return c:IsSetCard(0xc32a) and c:IsAbleToRemoveAsCost() and c:IsLocation(LOCATION_MZONE)
	end
end
function s.spcon0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return Duel.IsExistingMatchingCard(s.spf0,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),e:GetHandler(),ft,tp)
end
function s.spop0(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,s.spf0,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),e:GetHandler(),ft,tp)
	local rc=g1:GetFirst()
	local g2=Duel.SelectMatchingCard(tp,s.spf1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),rc,ft)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

--e1
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x32a,2,REASON_COST) and not e:GetHandler():IsHasEffect(EFFECT_EXTRA_ATTACK) end
	e:GetHandler():RemoveCounter(tp,0x32a,2,REASON_COST)
end
function s.daop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFaceup() and not e:GetHandler():IsHasEffect(EFFECT_EXTRA_ATTACK) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end

--e2
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_REMOVED)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(e:GetHandler())
	e1:SetOperation(s.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c and c:IsLocation(LOCATION_REMOVED) and c:IsAbleToHand() then
		Duel.Hint(HINT_CARD,0,id)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end