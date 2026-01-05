--奥梅提奥托的溶星神殿
local s,id=GetID()

s.named_with_LavaAstral=1
function s.LavaAstral(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_LavaAstral
end

local OME_ID=40020321

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(s.protfilter)
	e2:SetValue(s.protval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(s.actcon)
	e4:SetValue(s.aclimit)
	c:RegisterEffect(e4)
end

function s.thfilter(c)
	return c:IsCode(OME_ID) and c:IsAbleToHand()
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function s.protfilter(c)
	return s.LavaAstral(c)
end

function s.protval(e,c,rp)
	return rp==1-e:GetHandlerPlayer()
end

function s.omepzfilter(c)
	return c:IsFaceup() and c:IsCode(OME_ID)
end

function s.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.omepzfilter,tp,LOCATION_PZONE,0,1,nil)
end

function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	
	if not (re:IsHasType(EFFECT_TYPE_TRIGGER_O) or re:IsHasType(EFFECT_TYPE_TRIGGER_F)) then return false end

	local code=re:GetCode()
	local is_destruction_trigger = (code==EVENT_DESTROYED or code==EVENT_BATTLE_DESTROYED 
								 or code==EVENT_TO_GRAVE or code==EVENT_LEAVE_FIELD 
								 or code==EVENT_TO_HAND or code==EVENT_TO_DECK 
								 or code==EVENT_REMOVE) -- 包含被除外的情况
	
	return is_destruction_trigger and rc:IsReason(REASON_DESTROY)
end
