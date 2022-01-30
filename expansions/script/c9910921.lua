--劫掠匪魔
function c9910921.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c9910921.indcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3954))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9910921)
	e3:SetTarget(c9910921.damtg)
	e3:SetOperation(c9910921.damop)
	c:RegisterEffect(e3)
end
function c9910921.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsLevelAbove(7)
end
function c9910921.indcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c9910921.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910921.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
	if Duel.GetCurrentChain()>1 then
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	end
end
function c9910921.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	if Duel.Damage(1-tp,300,REASON_EFFECT)~=0 and Duel.GetCurrentChain()>1 and #g>0
		and Duel.SelectYesNo(tp,aux.Stringid(9910921,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end
