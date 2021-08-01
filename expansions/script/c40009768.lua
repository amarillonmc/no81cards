--魔惧会 贵妇之维奥拉
function c40009768.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_FIEND),1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009768,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40009768)
	e1:SetCost(c40009768.spcost)
	e1:SetTarget(c40009768.settg)
	e1:SetOperation(c40009768.setop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c40009768.condtion)
	e2:SetValue(2500)
	c:RegisterEffect(e2)
end
function c40009768.rfilter(c)
	return c:IsRace(RACE_PLANT)
end
function c40009768.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c40009768.rfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c40009768.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c40009768.filter(c)
	return c:IsCode(40009637) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c40009768.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c40009768.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c40009768.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c40009768.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
function c40009768.cfilter(c)
	return c:IsFaceup() and c:IsCode(40009560)
end
function c40009768.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and Duel.GetAttacker()==e:GetHandler() and Duel.IsExistingMatchingCard(c40009768.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetFlagEffect(tp,40009560)>0
end