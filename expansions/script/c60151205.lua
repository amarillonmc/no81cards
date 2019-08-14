--痛觉残留 两仪式
function c60151205.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
    local e99=Effect.CreateEffect(c)
    e99:SetType(EFFECT_TYPE_SINGLE)
    e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e99:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e99)
	--destroy
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_BATTLE_CONFIRM)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c60151205.condition2)
    e1:SetOperation(c60151205.desop)
    c:RegisterEffect(e1)
	--tohand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,60151205)
	e2:SetCondition(c60151205.thcon)
    e2:SetCost(c60151205.thcost)
    e2:SetTarget(c60151205.thtg)
    e2:SetOperation(c60151205.thop)
    c:RegisterEffect(e2)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,6011205)
    e3:SetTarget(c60151205.target)
    e3:SetOperation(c60151205.activate)
    c:RegisterEffect(e3)
end
function c60151205.condition2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	return c:IsFaceup()
end
function c60151205.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:GetBattleTarget()==nil then return end
    if tc:IsRelateToBattle() and tc:IsFaceup() and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
        local atk=c:GetAttack()
		local atk1=tc:GetAttack()
		local def1=tc:GetDefense()
		if c:GetFlagEffect(60151298)>0 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,0))
			Duel.Hint(HINT_CARD,0,60151205)
			if Duel.SendtoGrave(tc,REASON_RULE)~=0 then
				local atk2=tc:GetBaseAttack()
				if atk>atk2 then Duel.BreakEffect()
					Duel.Damage(1-tp,atk-atk2,REASON_EFFECT)
				end
				if atk2>atk then Duel.BreakEffect()
					Duel.Damage(1-tp,atk2-atk,REASON_EFFECT)
				end
			end
		else
			if atk>atk1 or atk>def1 then
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,1))
				Duel.Hint(HINT_CARD,0,60151205)
				if Duel.SendtoGrave(tc,REASON_RULE)~=0 then
					local atk2=tc:GetBaseAttack()
					if atk>atk2 then Duel.BreakEffect()
						Duel.Damage(1-tp,atk-atk2,REASON_EFFECT)
					end
					if atk2>atk then Duel.BreakEffect()
						Duel.Damage(1-tp,atk2-atk,REASON_EFFECT)
					end
				end
			end
		end
    end
end
function c60151205.cfilter(c)
    return c:IsFaceup() and bit.band(c:GetType(),0x81)==0x81
end
function c60151205.thcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c60151205.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60151205.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c60151205.thfilter(c)
    return c:IsCode(60151299) and c:IsAbleToHand()
end
function c60151205.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151205.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60151205.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60151205.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60151205.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tg=g:GetMaxGroup(Card.GetAttack)
	local atk=tg:GetFirst():GetAttack()
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c60151205.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local tg=g:GetMaxGroup(Card.GetAttack)
		local atk=tg:GetFirst():GetAttack()
        if Duel.Damage(1-tp,atk,REASON_EFFECT)~=0 then
			local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			local tc=g1:GetFirst()
			while tc do
				local atk2=tc:GetAttack()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(atk2/2)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				tc=g1:GetNext()
			end
		end
    end
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end