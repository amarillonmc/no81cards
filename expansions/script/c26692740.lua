--暗黑界的邪神 布鲁德
function c26692740.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),3)
	c:EnableReviveLimit()
	--adjust
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(c26692740.adjustop)
	c:RegisterEffect(e0)
	--change effect type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(26692740)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c26692740.cetcon)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26692740,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c26692740.discon)
	e2:SetTarget(c26692740.distg)
	e2:SetOperation(c26692740.disop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26692740,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c26692740.thcon)
	e3:SetTarget(c26692740.thtg)
	e3:SetOperation(c26692740.thop)
	c:RegisterEffect(e3)
end
function c26692740.cetcon(e)
	return e:GetHandler():GetSequence()>4
end
function c26692740.filter(c)
	return c:IsSetCard(0x6) and c:IsType(TYPE_MONSTER)
end
function c26692740.actarget(e,te,tp)
	return (not Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),26692740) and te:GetValue()==26692740) or (Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),26692740) and te:GetValue()==26692741)
end
function c26692740.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not c26692740.globle_check then
		c26692740.globle_check=true
		local ge1=Effect.CreateEffect(e:GetHandler())
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCost(aux.FALSE)
		ge1:SetTargetRange(1,1)
		ge1:SetTarget(c26692740.actarget)
		Duel.RegisterEffect(ge1,0)
		local g=Duel.GetMatchingGroup(c26692740.filter,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil)
		cregister=Card.RegisterEffect
		table_effect={}
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:GetCode()~=EVENT_TO_GRAVE then
				local eff=effect:Clone()
				table.insert(table_effect,eff)
			end
			if effect and effect:GetCode()==EVENT_TO_GRAVE then
				local eff=effect:Clone()
				local eff2=effect:Clone()
				local tg=eff:GetTarget()
				local op=eff:GetOperation()
				eff:SetValue(26692740)
				eff:SetTarget(
				function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
					if chk==0 then
						return tg(e,tp,eg,ep,ev,re,r,1-tp,0,chkc)
					end
					Duel.Hint(HINT_CARD,0,26692740)
					tg(e,tp,eg,ep,ev,re,r,1-tp,chk,chkc)
				end)
				eff:SetOperation(
				function(e,tp,eg,ep,ev,re,r,rp)
					Duel.Hint(HINT_CARD,0,26692740)
					op(e,tp,eg,ep,ev,re,r,1-tp)
				end)
				table.insert(table_effect,eff)
				eff2:SetValue(26692741)
				table.insert(table_effect,eff2)
			end
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			tc:ReplaceEffect(34822855,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
		end
		Card.RegisterEffect=cregister
	end
	e:Reset()
end

function c26692740.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp==1-tp
end
function c26692740.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6)
end
function c26692740.dcfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c26692740.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup()
	local g=g:Filter(c26692740.ctfilter,nil)
	if chk==0 then return c:GetFlagEffect(26692740)+1<=g:GetCount() and Duel.IsExistingMatchingCard(c26692740.dcfilter,tp,LOCATION_HAND,0,1,nil) end
	c:RegisterFlagEffect(26692740,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c26692740.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		Duel.DiscardHand(tp,c26692740.dcfilter,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c26692740.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_DESTROY) and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c26692740.thfilter(c)
	return c:IsSetCard(0x6) and c:IsAbleToHand()
end
function c26692740.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26692740.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26692740.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26692740.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
