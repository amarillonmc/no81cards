--咒鬼的夜都
local s,id=GetID()
s.named_with_OgreWizard=1

function s.OgreWizard(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_OgreWizard
end

function s.initial_effect(c)

	aux.AddCodeList(c,40021086)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.eff1con)
	e2:SetTarget(s.eff1tg)
	e2:SetOperation(s.eff1op)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,id+1)
	e3:SetCost(s.eff2cost)
	e3:SetTarget(s.eff2tg)
	e3:SetOperation(s.eff2op)
	c:RegisterEffect(e3)
end

function s.hera_filter(c)
	return c:IsFaceup() and c:IsCode(40021086)
end
function s.hera_check(tp)
	return Duel.IsExistingMatchingCard(s.hera_filter,tp,LOCATION_EXTRA+LOCATION_PZONE,0,1,nil)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1 = s.hera_check(tp) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 
		and Duel.IsPlayerCanDraw(tp,1) and e:CheckCountLimit(tp)
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		e:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		e:SetLabel(1)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	else
		e:SetCategory(0)
		e:SetLabel(0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==1 then
		if not s.hera_check(tp) then return end
		local ct=Duel.DiscardDeck(tp,1,REASON_EFFECT)
		if ct>0 then
			local g=Duel.GetOperatedGroup()
			local tc=g:GetFirst()
			if tc and tc:IsLocation(LOCATION_GRAVE) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end

function s.eff1con(e,tp,eg,ep,ev,re,r,rp)
	return s.hera_check(tp)
end
function s.eff1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.eff1op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not s.hera_check(tp) then return end
	local ct=Duel.DiscardDeck(tp,1,REASON_EFFECT)
	if ct>0 then
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		if tc and tc:IsLocation(LOCATION_GRAVE) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

function s.eff2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.atkfilter(c)
	return s.OgreWizard(c) and c:IsFaceup()
end
function s.eff2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.eff2op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then

		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
