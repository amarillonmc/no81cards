--方舟骑士·典雅噩兆 拉普兰德
function c82567857.initial_effect(c)
	c:EnableReviveLimit()
	--ATK Gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c82567857.val)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567857,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c82567857.cost)
	e2:SetCondition(c82567857.con)
	e2:SetOperation(c82567857.operation)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c82567857.thcon)
	e3:SetOperation(c82567857.thop)
	c:RegisterEffect(e3)
end
function c82567857.filter(c)
	return c:GetLevel()>=4 and c:IsFaceup()
end
function c82567857.val(e,c)
	return Duel.GetMatchingGroupCount(c82567857.filter,c:GetControler(),0,LOCATION_MZONE,nil)*500
end
function c82567857.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackAbove(500) end 
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		c:RegisterEffect(e1)
		end
	end
function c82567857.con(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil)
end
function c82567857.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() 
		then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		bc:RegisterEffect(e4)
		local e3=Effect.CreateEffect(c)
				  e3:SetType(EFFECT_TYPE_SINGLE)
				  e3:SetCode(EFFECT_DISABLE)
				  e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				  bc:RegisterEffect(e3)
	end
end
function c82567857.rtfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c82567857.rtfilter2(c)
	return c:IsCode(82567785)
end
function c82567857.thcon(e,c)
	local c=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c82567857.rtfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c82567857.rtfilter2,tp,LOCATION_GRAVE,0,1,nil)
end
function c82567857.thop(e,tp,eg,ep,ev,re,r,rp,c)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c82567857.rtfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local thg=Duel.SelectMatchingCard(tp,c82567857.rtfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if thg:GetCount()>0 then
	Duel.SendtoHand(thg,nil,REASON_EFFECT)
	 Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thg)
	   Duel.ConfirmCards(1-tp,c)
	Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c82567857.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
end
function c82567857.splimit(e,c)
	return not c:IsType(TYPE_RITUAL) 
end