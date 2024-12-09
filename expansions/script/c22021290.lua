--人理之诗 苍天已死，黄天当立
function c22021290.initial_effect(c)
	aux.AddCodeList(c,22021210)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attribute change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22021290,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,22021290)
	e2:SetCondition(c22021290.tgcon)
	e2:SetTarget(c22021290.attg)
	e2:SetOperation(c22021290.atop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c22021290.atktg1)
	e3:SetValue(c22021290.efilter)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetTarget(c22021290.atktg1)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetTarget(c22021290.atktg2)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetTarget(c22021290.atktg3)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetTarget(c22021290.atktg4)
	c:RegisterEffect(e7)
	local e8=e3:Clone()
	e8:SetTarget(c22021290.atktg5)
	c:RegisterEffect(e8)
	local e9=e3:Clone()
	e9:SetTarget(c22021290.atktg6)
	c:RegisterEffect(e9)
	local e10=e3:Clone()
	e10:SetTarget(c22021290.atktg7)
	c:RegisterEffect(e10)
	--spsummon
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(22021290,1))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DAMAGE)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_FZONE)
	e11:SetCountLimit(1,c22021291)
	e11:SetCondition(c22021290.condition)
	e11:SetTarget(c22021290.sptg)
	e11:SetOperation(c22021290.spop)
	c:RegisterEffect(e11)
end
function c22021290.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c22021290.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	e:SetLabel(rc)
end
function c22021290.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22021290.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c22021290.atktg1(e,c)
	return (c:IsAttribute(ATTRIBUTE_DARK) and (c:IsAttribute(ATTRIBUTE_DEVINE) or c:IsAttribute(ATTRIBUTE_EARTH) or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_WIND))) and c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22021290.atktg2(e,c)
	return (c:IsAttribute(ATTRIBUTE_DEVINE) and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_EARTH) or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_WIND))) and c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22021290.atktg3(e,c)
	return (c:IsAttribute(ATTRIBUTE_EARTH) and (c:IsAttribute(ATTRIBUTE_DEVINE) or c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_WIND))) and c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22021290.atktg4(e,c)
	return (c:IsAttribute(ATTRIBUTE_FIRE) and (c:IsAttribute(ATTRIBUTE_DEVINE) or c:IsAttribute(ATTRIBUTE_EARTH) or c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_WIND))) and c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22021290.atktg5(e,c)
	return (c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsAttribute(ATTRIBUTE_DEVINE) or c:IsAttribute(ATTRIBUTE_EARTH) or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_WIND))) and c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22021290.atktg6(e,c)
	return (c:IsAttribute(ATTRIBUTE_WATER) and (c:IsAttribute(ATTRIBUTE_DEVINE) or c:IsAttribute(ATTRIBUTE_EARTH) or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_WIND))) and c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22021290.atktg7(e,c)
	return (c:IsAttribute(ATTRIBUTE_WIND) and (c:IsAttribute(ATTRIBUTE_DEVINE) or c:IsAttribute(ATTRIBUTE_EARTH) or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_DARK))) and c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22021290.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,22021211,0,TYPES_TOKEN_MONSTER,500,600,1,RACE_MACHINE,ATTRIBUTE_DARK) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22021290.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,22021211,0,TYPES_TOKEN_MONSTER,500,600,1,RACE_MACHINE,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,22021211)
			if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c22021290.cfilter(c)
	return c:IsFaceup() and c:IsCode(22021210)
end
function c22021290.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22021210.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end