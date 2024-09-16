--人理之基 克洛伊
function c22020580.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c22020580.mfilter1,c22020580.mfilter2,1,1,true)
	aux.EnableChangeCode(c,22020220,LOCATION_MZONE+LOCATION_GRAVE)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020580,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22020580)
	e1:SetTarget(c22020580.atktg)
	e1:SetOperation(c22020580.atkop)
	c:RegisterEffect(e1)
end
c22020580.effect_canequip_hogu=true
function c22020580.mfilter1(c)
	return c:IsRace(RACE_WARRIOR) and c:IsFusionSetCard(0xff1)
end
function c22020580.mfilter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsFusionSetCard(0xff1)
end
function c22020580.atkfilter(c,atk)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsAttackAbove(1)
end
function c22020580.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc~=c and c22020580.atkfilter(chkc,atk) end
	if chk==0 then return Duel.IsExistingTarget(c22020580.atkfilter,tp,LOCATION_MZONE,0,1,c,atk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22020580.atkfilter,tp,LOCATION_MZONE,0,1,1,c,atk)
end
function c22020580.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsType(TYPE_FUSION) and aux.IsMaterialListCode(tc,22020530) then
		Duel.SelectOption(tp,aux.Stringid(22020580,2))
		Duel.SelectOption(tp,aux.Stringid(22020580,3))
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(22020580,1))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
