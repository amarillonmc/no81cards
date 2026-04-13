--辉光序曲「Empre」-"群体跃迁准备!"
function c51847220.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Empre
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(51847220)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51847220,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c51847220.spcon)
	e2:SetTarget(c51847220.sptg)
	e2:SetOperation(c51847220.spop)
	c:RegisterEffect(e2)
end
function c51847220.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==Duel.GetTurnPlayer() and re:GetHandler()~=e:GetHandler()
end
function c51847220.spfilter(c,e,tp)
	return c:IsSetCard(0xa68) and c:IsType(TYPE_SPELL) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0xa68,TYPE_NORMAL+TYPE_MONSTER+TYPE_SPELL,2700,1300,6,RACE_MACHINE,ATTRIBUTE_LIGHT) and c:IsFaceupEx()
end
function c51847220.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanRemove(tp)
		and Duel.IsExistingMatchingCard(c51847220.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c51847220.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c51847220.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if not sc then return end
	sc:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_LIGHT,RACE_MACHINE,6,2700,1300)
	if Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		sc:RegisterEffect(e1,true)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil):GetFirst()
		if not tc then return end
		Duel.HintSelection(Group.FromCards(tc))
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
