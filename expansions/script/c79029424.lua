--维多利亚·先锋干员-风笛·高效冲击
function c79029424.initial_effect(c)
	c:EnableReviveLimit()
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(79029179)
	c:RegisterEffect(e1) 
	--double
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029424,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c79029424.discon)
	e3:SetTarget(c79029424.distg)
	e3:SetOperation(c79029424.disop)
	c:RegisterEffect(e3) 
	--change atk
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_CONFIRM)
	e4:SetCountLimit(1)
	e4:SetCondition(c79029424.atkcon)
	e4:SetCost(c79029424.atkcost)
	e4:SetOperation(c79029424.atkop)
	c:RegisterEffect(e4)
	--SpecialSummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(79029424,0)) 
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,79029424)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c79029424.spcost)
	e5:SetTarget(c79029424.sptg)
	e5:SetOperation(c79029424.spop)
	c:RegisterEffect(e5)
end
function c79029424.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79029424.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c79029424.disop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("“战术使人思维明晰！”")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029424,1))
	if Duel.NegateActivation(ev) and Duel.Equip(tp,eg:GetFirst(),e:GetHandler()) then   
		--
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c79029424.eqlimit)
		eg:GetFirst():RegisterEffect(e1)
	end
end
function c79029424.eqlimit(e,c)
	return e:GetOwner()==c
end
function c79029424.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() and bc:GetAttack()>0
end
function c79029424.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetEquipGroup()
	if chk==0 then return g:Filter(Card.IsAbleToGraveAsCost,nil):GetCount()>0 end
	local tc=g:Filter(Card.IsAbleToGraveAsCost,nil):Select(tp,1,1,nil)
	Duel.SendtoGrave(tc,REASON_COST)
end
function c79029424.atkop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("“勇敢能够击溃邪恶！”")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029424,2))
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if tc:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local atk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetValue(atk)
			c:RegisterEffect(e2)
		end
	end
end
function c79029424.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_COST)
end
function c79029424.spfil(c,e,tp)
	return c:IsSetCard(0xa903) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029424.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029424.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c79029424.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029424.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Debug.Message("全体散开！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029424,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	local atk=tc:GetAttack()
	Duel.Recover(tp,atk,REASON_EFFECT)
end



