--喀兰贸易·特种干员-崖心
function c79029069.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c79029069.matfilter,2,3)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79029069)
	e1:SetCondition(c79029069.condition)
	e1:SetTarget(c79029069.target)
	e1:SetOperation(c79029069.activate)
	c:RegisterEffect(e1)	
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c79029069.rdcon)
	e3:SetOperation(c79029069.rdop)
	c:RegisterEffect(e3)
end
function c79029069.matfilter(c)
	return c:IsLinkSetCard(0xa900)
end
function c79029069.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c79029069.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c79029069.condition(e,tp,eg,ep,ev,re,r,rp)
		local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc==e:GetHandler()
end
function c79029069.filter2(c)
	return c:IsControlerCanBeChanged()
end
function c79029069.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()~=0 then
			return end
	end
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,1-tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingTarget(c79029069.filter2,1-tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029070) then
			op=Duel.SelectOption(tp,aux.Stringid(9418365,0),aux.Stringid(80117527,1),aux.Stringid(86686671,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(9418365,0),aux.Stringid(80117527,0))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9418365,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(80117527,0))+1
	end
	e:SetLabel(op)
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,c79029069.filter2,1-tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else
		e:SetProperty(0)
	end
end
function c79029069.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op~=1 then
		local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0)
		if g:GetCount()==0 then return end
		local sg=g:RandomSelect(ep,1)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
		end
	if op~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			if op==2 then Duel.BreakEffect() end
		   Duel.GetControl(tc,tp)
		end
	end
end



