--半魔的兽使
local s,id=GetID()
local CARD_ELSA = 17337396
local SET_HALF_FIEND = 0x3f50
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.efcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.halftg)
	e3:SetOperation(s.halfop)
	c:RegisterEffect(e3)
end

function s.is_elsa_or_half(c)
	return c:IsFaceup() and (c:IsSetCard(SET_HALF_FIEND) or c:IsCode(CARD_ELSA))
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp) and s.is_elsa_or_half(d)
end

function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.tfilter,1,nil,tp)
end

function s.tfilter(c,tp)
	return c:IsControler(tp) and s.is_elsa_or_half(c) and c:IsLocation(LOCATION_MZONE)
end
function s.reveal_filter(c,mc)
	return s.is_elsa_or_half(c) and c~=mc
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.reveal_filter,tp,LOCATION_MZONE,0,1,c,c)
			and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,1-tp,LOCATION_MZONE)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown()) then return end	  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.reveal_filter,tp,LOCATION_MZONE,0,1,1,c,c)
	local tc=g:GetFirst()
	if tc then	  
		local rg=Group.FromCards(c,tc)
		Duel.ConfirmCards(1-tp,rg)
		if c:IsLocation(LOCATION_HAND) then 
			Duel.ShuffleHand(tp) 
		end
		local sum=math.floor((math.max(0,c:GetBaseAttack())+math.max(0,tc:GetBaseAttack()))/2)	   
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local oppg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		local opptc=oppg:GetFirst()
		if opptc and not opptc:IsImmuneToEffect(e) then
			local preatk=opptc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-sum)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			opptc:RegisterEffect(e1)
			if preatk~=0 and opptc:IsAttack(0) and opptc:IsControlerCanBeChanged() then
				if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.BreakEffect()
					Duel.GetControl(opptc,tp,PHASE_END,1)
				end
			end
		end
	end
end
function s.halftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,nil,1,0,0)
end
function s.halfop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(math.ceil(tc:GetAttack()/2))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)		
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(math.ceil(tc:GetDefense()/2))
		tc:RegisterEffect(e2)
	end
end