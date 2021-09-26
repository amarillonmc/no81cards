--极翼灵兽 暴飞龙
function c45745929.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c45745929.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()	
	--select
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c45745929.setg)
	e1:SetOperation(c45745929.seop)
	c:RegisterEffect(e1)  
	--Must attack this card
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c45745929.effcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e3:SetValue(c45745929.atklimit)
	c:RegisterEffect(e3)
	--double
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetCondition(c45745929.damcon)
	e4:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e4)  
end

function c45745929.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x881)
end

--e1
function c45745929.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c45745929.seop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
		op=Duel.SelectOption(tp,aux.Stringid(45745929,0),aux.Stringid(45745929,1))
	else
		op=1
	end
	if op==0 then
		e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(45745929,0))
		e:GetHandler():SetHint(CHINT_DESC,aux.Stringid(45745929,0))
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-1000)
			tc:RegisterEffect(e1)
		end
	else
		e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(45745929,1))
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_ATKCHANGE)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e2:SetTarget(c45745929.atktg)
		e2:SetOperation(c45745929.atkop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end
function c45745929.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER) and c:IsStatus(STATUS_OPPO_BATTLE)
end
function c45745929.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(500)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
end

--e2e3
function c45745929.effcon(e)
	return Duel.GetTurnCount()>=e:GetLabel()+1
end
function c45745929.atklimit(e,c)
	return c==e:GetHandler()
end

--e4
function c45745929.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end