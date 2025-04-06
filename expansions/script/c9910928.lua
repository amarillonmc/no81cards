--蛊惑匪魔
function c9910928.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c9910928.limcon)
	e2:SetTarget(c9910928.rmlimit)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9910928)
	e3:SetTarget(c9910928.damtg)
	e3:SetOperation(c9910928.damop)
	c:RegisterEffect(e3)
end
function c9910928.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsLevelAbove(7)
end
function c9910928.limcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c9910928.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910928.rmlimit(e,c)
	return c:IsLocation(LOCATION_GRAVE)
end
function c9910928.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
	if Duel.GetCurrentChain()>1 then
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	else
		e:SetCategory(CATEGORY_DAMAGE)
	end
end
function c9910928.spfilter1(c,e,tp)
	return c:IsSetCard(0x3954) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910928.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910928.damop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(1-tp,5)
	local g2=Duel.GetMatchingGroup(c9910928.spfilter1,tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.Damage(1-tp,300,REASON_EFFECT)~=0 and Duel.GetCurrentChain()>1 and #g1==5 and #g2>0
		and Duel.SelectYesNo(tp,aux.Stringid(9910928,0)) then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g2:Merge(g1:Filter(c9910928.spfilter2,nil,e,tp))
		local sg=g2:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.ShuffleDeck(1-tp)
	end
end
