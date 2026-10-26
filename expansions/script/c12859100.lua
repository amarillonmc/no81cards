--澄极精之秋英宇宙星
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12859060)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.matfilter,2,true)
	-- 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1190)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.fuscon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.indtg)
	e2:SetValue(s.indct)
	c:RegisterEffect(e2)
end
function s.matfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAttack(900)
end
function s.fuscon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.thfilter(c)
  return c:IsCode(12859060) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #sg==0 then return end
	Duel.HintSelection(sg)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and sg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,sg)
		if c:IsRelateToChain() and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN+RESET_DISABLE)
			e1:SetValue(400)
			c:RegisterEffect(e1)
			--double damage
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE)
			e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	end
end
function s.indtg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_FUSION)
end
function s.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end