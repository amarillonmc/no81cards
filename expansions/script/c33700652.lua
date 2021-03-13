if not pcall(function() require("expansions/script/c33700650") end) then require("script/c33700650") end
--破天神狐 壹柒〇〇·七六八九七八六九
local m=33700652
local cm=_G["c"..m]
cm.named_with_ptsh=true
function cm.initial_effect(c)
	local e1=sr_ptsh.Cmeffect(c,m)
	
	local e2=sr_ptsh.efeffect(c,m,CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE,EVENT_CHAINING,EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)

	local e3=sr_ptsh.opeffect(c,m)
end
function cm.tfilter(c,tp)
	return c:IsFacedown() and c:IsControler(tp)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(cm.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Card.CancelToGrave(re:GetHandler())
		Duel.SendtoHand(re:GetHandler(),nil,REASON_EFFECT)
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.geteffect(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	e3:SetCondition(cm.damcon)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	e1:SetCondition(cm.damcon1)
	e1:SetOperation(cm.damop)
	c:RegisterEffect(e1)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	e:GetHandler():RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(m+100)~=0 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local lp=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,math.max(0,lp-5000))
end
function cm.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup()
end