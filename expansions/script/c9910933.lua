--处刑匪魔
function c9910933.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	--can not be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetCondition(c9910933.indcon)
	e2:SetTarget(c9910933.etlimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9910933)
	e3:SetTarget(c9910933.damtg)
	e3:SetOperation(c9910933.damop)
	c:RegisterEffect(e3)
end
function c9910933.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsLevelAbove(7)
end
function c9910933.indcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c9910933.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910933.etlimit(e,c)
	return c~=e:GetHandler()
end
function c9910933.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c9910933.setfilter1(c)
	return c:IsSetCard(0x3954) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c9910933.setfilter2(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c9910933.damop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.GetMatchingGroup(c9910933.setfilter1,tp,LOCATION_DECK,0,nil)
	if Duel.Damage(1-tp,300,REASON_EFFECT)~=0 and Duel.GetCurrentChain()>1 and #g1>0 and #g2>0
		and Duel.SelectYesNo(tp,aux.Stringid(9910933,0)) then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		g2:Merge(g1:Filter(c9910933.setfilter2,nil))
		local sg=g2:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SSet(tp,sg:GetFirst())
		end
		Duel.ShuffleHand(1-tp)
	end
end
