-- 键★记忆 梦之迹 / Memoria K.E.Y - Sogno Residuo
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),4,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.imcon)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--excavate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(s.exccon)
	e3:SetCost(s.exccost)
	e3:SetTarget(s.exctg)
	e3:SetOperation(s.excop)
	c:RegisterEffect(e3)
end
function s.imcon(e)
	return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetOverlayCount()==0
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end

function s.exccon(e)
	return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x460)
end
function s.exccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.exctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=7 end
end
function s.excop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<7 then return end
	local c=e:GetHandler()
	local rc=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(aux.FilterEqualFunction(Card.GetSequence,6),nil):GetFirst()
	if not rc then return end
	Duel.ConfirmCards(1-tp,rc)
	Duel.RaiseEvent(Group.FromCards(rc),EVENT_CUSTOM+33730024,e,REASON_EFFECT+REASON_REVEAL,tp,nil,SEQ_DECKBOTTOM)
	local match=false
	if rc:IsSetCard(0x460) then
		if not match then match=true end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and rc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if rc:IsAttribute(ATTRIBUTE_WATER) and rc:IsRace(RACE_AQUA) then
		if not match then match=true end
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(id,1))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2)
		end
	end
	if rc:IsCode(33730020) then
		if not match then match=true end
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(3000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetType(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
	if not match and rc:IsLocation(LOCATION_DECK) then
		Duel.MoveSequence(rc,0)
	end
end