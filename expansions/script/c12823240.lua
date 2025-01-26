--舞斗-神乐樱刃舞
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(s.con2)
	c:RegisterEffect(e3)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
function s.atkfilter(c)
	return c:IsOriginalSetCard(0xaa70) and c:IsFaceup()
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==4
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,12823220)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local cl=Duel.GetCurrentChain()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		tc:RegisterFlagEffect(12823205,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,0,nil)
		local tg=g:GetMaxGroup(Card.GetAttack)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=tg:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_RULE)
		end
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(12823285)
end
function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
