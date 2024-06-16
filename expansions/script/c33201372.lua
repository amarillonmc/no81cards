--唤祐重器 战国铜冰鉴
local s,id,o=GetID()
Duel.LoadScript("c33201370.lua")
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCondition(s.con)
	e2:SetTarget(s.rltg)
	e2:SetOperation(s.rlop)
	c:RegisterEffect(e2)
end
s.VHisc_HYZQ=true
s.VHisc_CNTreasure=true

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(VHisc_HYZQ.rlft,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) and VHisc_HYZQ.mck(tp,id) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,VHisc_HYZQ.rlft,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local ct=Duel.SendtoGrave(g,REASON_RELEASE)
	VHisc_HYZQ.mop(e,tp,m)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function s.ft(c)
	return c.VHisc_HYZQ and not c:IsCode(33201371) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPES_NORMAL_TRAP_MONSTER,1500,1500,4,RACE_ROCK,ATTRIBUTE_EARTH)
end

--Release effect
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_END
end
function s.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,0)
end
function s.rlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(c)
	e1:SetOperation(s.rthop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.rthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(s.rthft,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.rthft,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			g:AddCard(c)
			Duel.Hint(HINT_CARD,tp,id)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.rthft(c)
	return c.VHisc_HYZQ and c:IsAbleToHand() and not c:IsCode(id)
end