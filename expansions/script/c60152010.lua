--无畏的勇气 佐仓杏子
function c60152010.initial_effect(c)
	--sp
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e12:SetRange(LOCATION_HAND)
	e12:SetCondition(c60152010.spcon2)
	e12:SetOperation(c60152010.spop2)
	c:RegisterEffect(e12)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60152010,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,60152010)
    e1:SetCondition(c60152010.con)
	e1:SetTarget(c60152010.target)
	e1:SetOperation(c60152010.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60152010,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,6012010)
    e3:SetCondition(c60152010.con)
	e3:SetTarget(c60152010.sptg)
	e3:SetOperation(c60152010.spop)
	c:RegisterEffect(e3)
end
function c60152010.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c60152010.spfilter2(c)
	return ((c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER)) 
		or (c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_FIRE))) and c:IsReleasable()
end
function c60152010.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 then 
		return Duel.IsExistingMatchingCard(c60152010.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,e:GetHandler())
			and Duel.IsExistingMatchingCard(c60152010.spfilter2,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsExistingMatchingCard(c60152010.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,e:GetHandler())
	end
end
function c60152010.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g1=Duel.SelectMatchingCard(tp,c60152009.spfilter2,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		g1:AddCard(e:GetHandler())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=Duel.SelectMatchingCard(tp,c60152009.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,g1)
		g1:RemoveCard(e:GetHandler())
		local g=Group.CreateGroup()
		g:Merge(g1)
		g:Merge(g2)
		local tc2=g:GetFirst()
		while tc2 do
			if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
			tc2=g:GetNext()
		end
		Duel.Release(g,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g1=Duel.SelectMatchingCard(tp,c60152010.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,e:GetHandler())
		local tc=g1:GetFirst()
		while tc do
			if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
			tc=g1:GetNext()
		end
		Duel.Release(g1,REASON_COST)
	end
end
function c60152010.filter(c)
	return c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c60152010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60152010.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c60152010.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60152010.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(sc:GetAttack())
			sc:RegisterEffect(e1)
			sc=g:GetNext()
		end
	end
end
function c60152010.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6b25) and not c:IsCode(60152010) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60152010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60152010.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60152010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60152010.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.SpecialSummonComplete()
	end
end