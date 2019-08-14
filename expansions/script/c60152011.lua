--红色幽灵 佐仓杏子
function c60152011.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	e11:SetValue(aux.FALSE)
	c:RegisterEffect(e11)
	--special summon
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e12:SetRange(LOCATION_HAND)
	e12:SetCondition(c60152011.spcon)
	e12:SetOperation(c60152011.spop)
	c:RegisterEffect(e12)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60152011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c60152011.spcost2)
	e1:SetOperation(c60152011.spop2)
	c:RegisterEffect(e1)
	--multiatk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60152011,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c60152011.atkcon)
	e2:SetTarget(c60152011.atktg)
	e2:SetOperation(c60152011.atkop)
	c:RegisterEffect(e2)
	--
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(60152011,1))
	--e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	--e3:SetCode(EVENT_RELEASE)
	--e3:SetTarget(c60152011.sptg)
	--e3:SetOperation(c60152011.spop3)
	--c:RegisterEffect(e3)
end
function c60152011.cfilter(c)
	return c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER) and not c:IsCode(60152011) and c:IsReleasable()
end
function c60152011.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
		and Duel.CheckReleaseGroup(c:GetControler(),c60152011.cfilter,3,nil)
end
function c60152011.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c60152011.cfilter,3,3,nil)
	local tc2=g:GetFirst()
	while tc2 do
		if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
		tc2=g:GetNext()
	end
	Duel.Release(g,REASON_COST)
end
function c60152011.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,e:GetHandler()) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60152098,0,0x4011,0,0,12,RACE_PYRO,ATTRIBUTE_FIRE) end
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,e:GetHandler())
	local ac=g:GetCount()
	e:SetLabel(ac)
	Duel.Release(g,REASON_COST)
end
function c60152011.filter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER)
end
function c60152011.atkfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER)
end
function c60152011.atkup(e,c)
	return Duel.GetMatchingGroupCount(c60152011.atkfilter,0,LOCATION_MZONE,0,nil)*400
end
function c60152011.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,60152098,0,0x4011,0,0,12,RACE_PYRO,ATTRIBUTE_FIRE) then
		local ct=e:GetLabel()
		local atk=Duel.GetMatchingGroupCount(c60152011.filter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)*400
		if ct==1 then
			local token=Duel.CreateToken(tp,60152098)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(atk)
			token:RegisterEffect(e1,true)
			Duel.SpecialSummonComplete()
		else
			for i=1,ct do
				local token=Duel.CreateToken(tp,60152098)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_SET_BASE_ATTACK)
				e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e4:SetRange(LOCATION_MZONE)
				e4:SetValue(atk)
				token:RegisterEffect(e4,true)
				
			end
			Duel.SpecialSummonComplete()
		end
	end
	
end
function c60152011.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c60152011.rfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c60152011.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60152011.rfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c60152011.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60152011.rfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local atk=Duel.GetMatchingGroupCount(c60152011.rfilter,tp,LOCATION_MZONE,0,nil)
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(60152011,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(60152009,2))
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PIERCE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(c60152011.val)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c60152011.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return dam/2
	else return dam end
end
function c60152011.filter2(c)
	return c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c60152011.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c60152011.filter2,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60152011.spop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c60152011.filter2,tp,LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end