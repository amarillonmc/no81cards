--溺水的天使
function c43990988.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SYNCHRO_LEVEL_EX)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSummonLocation,LOCATION_EXTRA))
	e0:SetValue(c43990988.synval)
	c:RegisterEffect(e0)
	--synchro level
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_SINGLE)
	ge0:SetCode(EFFECT_SYNCHRO_LEVEL)
	ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge0:SetRange(LOCATION_MZONE)
	ge0:SetValue(c43990988.synclv)
	--effect grant
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSummonLocation,LOCATION_EXTRA))
	e0:SetLabelObject(ge0)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c43990988.regcon)
	e1:SetOperation(c43990988.regop)
	c:RegisterEffect(e1)
	--material check
	local ce0=Effect.CreateEffect(c)
	ce0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ce0:SetCode(EVENT_SPSUMMON_SUCCESS)
	ce0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ce0:SetCondition(c43990988.matcon)
	ce0:SetOperation(c43990988.matop)
	c:RegisterEffect(ce0)
	local ce1=Effect.CreateEffect(c)
	ce1:SetType(EFFECT_TYPE_SINGLE)
	ce1:SetCode(EFFECT_MATERIAL_CHECK)
	ce1:SetValue(c43990988.valcheck)
	ce1:SetLabelObject(ce0)
	c:RegisterEffect(ce1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990988,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c43990988.chcon)
	e2:SetCost(c43990988.chcost)
	e2:SetTarget(c43990988.chtg)
	e2:SetOperation(c43990988.chop)
	c:RegisterEffect(e2)
	--protect battle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43990988,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c43990988.ptcon)
	e3:SetTarget(c43990988.pttg)
	e3:SetOperation(c43990988.ptop)
	c:RegisterEffect(e3)
	if not c43990988.global_check then
		c43990988.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c43990988.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_LEAVE_GRAVE)
		Duel.RegisterEffect(ge2,0)
	end
end
function c43990988.synclv(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c:IsOriginalCodeRule(43990988) then return (4<<16)+lv
	else
		return lv
	end
end
function c43990988.cfilter(c,p)
	return c:IsPreviousControler(p) and c:GetReasonPlayer()==1-p and not c:IsReason(REASON_RULE)
end
function c43990988.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c43990988.cfilter,nil,0)+eg:Filter(c43990988.cfilter,nil,1)
	for tc in aux.Next(g) do
		Duel.RegisterFlagEffect(tc:GetPreviousControler(),43990988,RESET_PHASE+PHASE_END,0,1)
	end
end
function c43990988.synval(e,syncard)
	if e:GetHandler()==syncard then
		return 4
	else
		return 0
	end
end
function c43990988.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c43990988.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c43990988.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c43990988.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,43990988)
	if Duel.GetFlagEffect(tp,43990988)==0 then return end
	local ct=Duel.GetFlagEffect(tp,43990988)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,ct,nil)
	if #g>0 then
		for tc in aux.Next(g) do tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true) end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		--Duel.ConfirmCards(1-tp,g)
	end
end
function c43990988.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c43990988.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(43990988,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c43990988.mcfilter(c)
	return c:IsLevelAbove(10) and c:IsType(TYPE_SYNCHRO)
end
function c43990988.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c43990988.mcfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c43990988.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetFlagEffect(43990988)>0
end
function c43990988.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100) end
	Duel.PayLPCost(tp,100)
end
function c43990988.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990988.desfilter,rp,0,LOCATION_MZONE,1,nil) end
end
function c43990988.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c43990988.repop)
end
function c43990988.desfilter(c)
	return c:IsCode(43990988) and c:IsFaceup() and c:IsAbleToGrave()
end
function c43990988.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43990988.desfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		if g:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			g=g:Select(1-tp,1,1,nil)
		end
		Duel.HintSelection(g)
		--Duel.Destroy(g,REASON_EFFECT)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c43990988.ptcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:IsControler(1-tp) and at:IsRelateToBattle()
end
function c43990988.pttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c43990988.ptop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end
