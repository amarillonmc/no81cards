--西风国际搜查 狼士龙
function c33200528.initial_effect(c)
	aux.AddCodeList(c,33200500)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,6,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200528,2))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCost(c33200528.cost)
	e1:SetTarget(c33200528.sctg)
	e1:SetOperation(c33200528.scop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--attack up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200528,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetTarget(c33200528.atktg)
	e3:SetOperation(c33200528.atkop)
	c:RegisterEffect(e3)
end

--e1
function c33200528.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33200528.filter(c)
	return c:IsFacedown()
end
function c33200528.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c33200528.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200528.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c33200528.filter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c33200528.scop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.ConfirmCards(tp,tc)
		local opt=e:GetLabel()
		if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end

--e2
function c33200528.exfilter(c)
   return not c:IsPublic()
end
function c33200528.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tm=Duel.GetFlagEffect(tp,33200503)
	if chk==0 then return Duel.GetFlagEffect(tp,e:GetHandler():GetOriginalCode())<tm+1 and Duel.IsExistingMatchingCard(c33200528.exfilter,tp,0,LOCATION_HAND,1,nil) end
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RegisterFlagEffect(33200500,RESET_EVENT+RESET_CHAIN,0,1)
	e:GetHandler():RegisterFlagEffect(33200599,RESET_EVENT+RESET_CHAIN,0,1)
end
function c33200528.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 or not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	if not Duel.IsPlayerAffectedByEffect(tp,33200505) then
		local sg=g:Filter(c33200501.exfilter,nil):RandomSelect(1-tp,1)
		local sgc=sg:GetFirst()
		Duel.ConfirmCards(tp,sgc)
		Duel.ShuffleHand(1-tp)
		local opt=e:GetLabel()
		if (opt==0 and sgc:IsType(TYPE_MONSTER)) or (opt==1 and sgc:IsType(TYPE_SPELL)) or (opt==2 and sgc:IsType(TYPE_TRAP)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(800)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	else
		Duel.ConfirmCards(tp,g)
		local sg=Duel.SelectMatchingCard(tp,c33200501.exfilter,tp,0,LOCATION_HAND,1,1,nil)
		local sgc=sg:GetFirst()
		Duel.ShuffleHand(1-tp)
		local opt=e:GetLabel()
		if (opt==0 and sgc:IsType(TYPE_MONSTER)) or (opt==1 and sgc:IsType(TYPE_SPELL)) or (opt==2 and sgc:IsType(TYPE_TRAP)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(800)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end