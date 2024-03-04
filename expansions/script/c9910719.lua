--远古造物 邓氏鱼
dofile("expansions/script/c9910700.lua")
function c9910719.initial_effect(c)
	--special summon
	QutryYgzw.AddSpProcedure(c,2)
	c:EnableReviveLimit()
	--flag
	QutryYgzw.AddTgFlag(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910719.negcon)
	e1:SetTarget(c9910719.negtg)
	e1:SetOperation(c9910719.negop)
	c:RegisterEffect(e1)
	--skip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910719,3))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c9910719.descon)
	e2:SetOperation(c9910719.desop)
	c:RegisterEffect(e2)
end
function c9910719.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9910719.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9910719.thfilter(c)
	return c:IsSetCard(0xc950) and c:IsAbleToHand()
end
function c9910719.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	local rc=re:GetHandler()
	local b=rc:IsRelateToEffect(re) and rc:IsDestructable()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910719.thfilter),tp,LOCATION_GRAVE,0,nil)
	local off=1
	local ops={}
	local opval={}
	if b then
		ops[off]=aux.Stringid(9910719,0)
		opval[off-1]=1
		off=off+1
	end
	if #g>0 then
		ops[off]=aux.Stringid(9910719,1)
		opval[off-1]=2
		off=off+1
	end
	ops[off]=aux.Stringid(9910719,2)
	opval[off-1]=3
	off=off+1
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.Destroy(rc,REASON_EFFECT)
	elseif opval[op]==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9910719.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():IsPreviousControler(tp)
end
function c9910719.desop(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	if Duel.GetTurnPlayer()~=tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c9910719.skipcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c9910719.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
