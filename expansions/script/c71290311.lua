-- 如舞动之翼
Duel.LoadScript("c71290308.lua")
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,71290308)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.negreg)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(s.negreg)
	e2:SetCondition(s.thcon)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(s.handcond)
	c:RegisterEffect(e4)
end
function s.negreg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(id+10000000,RESET_PHASE+PHASE_END,0,1)
end
function s.handcond(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,71290309)>0
end
function s.cfilter(c)
	return aux.IsCodeListed(c,71290308) and c:IsAbleToGrave()
end
function s.mfilter(c)
	return c:IsCode(71290308) and c:IsFaceup()
end
function s.spfilter(c,e,tp)
	return c:IsCode(71290308) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0) or Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_MZONE,0,1,nil)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if #sg>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		Duel.Draw(tp,2,REASON_EFFECT)
	end

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(s.negnextop)
	Duel.RegisterEffect(e1,tp)

	e:GetHandler():ResetFlagEffect(id+10000000)
	Lilith.allback(e,eg,ep,ev,re,r,rp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id+10000000)~=0
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	s.op1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id+10000000)
	Duel.RegisterFlagEffect(tp,71290308,0,0,1)
	Duel.RegisterFlagEffect(tp,id,0,0,1)
end
function s.negnextop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp then return end
	local rc=re:GetHandler()
	if not (rc:IsType(TYPE_SPELL) or rc:IsType(TYPE_TRAP)) then return end
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev)
		e:Reset()
	end
end