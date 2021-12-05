--煌闪之战兔·萨莉沙
function c72412550.initial_effect(c)
		--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WARRIOR),2,2)
	c:EnableReviveLimit()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--no damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetValue(c72412550.damlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetCondition(c72412550.batcon)
	e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e3)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72412550,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,72412550)
	e4:SetCondition(c72412550.regcon)
	e4:SetTarget(c72412550.regtg)
	e4:SetOperation(c72412550.regop)
	c:RegisterEffect(e4)
end
function c72412550.damlimit(e,c)
	if e:GetHandler():GetBattleTarget():IsAttribute(ATTRIBUTE_DARK) then
		return 1
	else return 0 end
end
function c72412550.batcon(e)
	return e:GetHandler():GetBattleTarget():IsAttribute(ATTRIBUTE_DARK)
end
function c72412550.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x6727) and c:GetPreviousControler()==tp and c:GetControler()==tp and c:GetLocation(LOCATION_GRAVE)
end
function c72412550.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c72412550.cfilter,1,nil,tp)
end
function c72412550.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return eg:IsContains(chkc) and c72412550.cfilter(chkc,tp) end
	if chk==0 then return eg:IsExists(c72412550.cfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=eg:FilterSelect(tp,c72412550.cfilter,1,1,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c72412550.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
	end
end