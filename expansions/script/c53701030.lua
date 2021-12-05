--惧 轮  镜 面 骑 士
function c53701030.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(SUMMON_VALUE_SELF)
	e1:SetCondition(c53701030.spcon)
	e1:SetOperation(c53701030.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c53701030.con)
	e2:SetOperation(c53701030.op)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c53701030.value)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c53701030.descon)
	e4:SetOperation(c53701030.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CUSTOM+53701033)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c53701030.desop)
	c:RegisterEffect(e6)
end
function c53701030.spfilter(c)
	return c:IsSetCard(0x3530) and c:IsType(TYPE_MONSTER)
end
function c53701030.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c53701030.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c53701030.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=Duel.SelectMatchingCard(tp,c53701030.spfilter,tp,LOCATION_HAND,0,1,1,c):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	e:GetLabelObject():SetLabelObject(tc)
end
function c53701030.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c53701030.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	e:GetHandler():CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
end
function c53701030.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*300
end
function c53701030.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3530) and c:IsControler(tp) and c:IsAttackPos()
end
function c53701030.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	e:SetLabelObject(tc)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c53701030.cfilter,1,nil,tp)
end
function c53701030.desfilter1(c,mc)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsCode(53701009) and c:GetLinkedGroup():IsContains(mc)
end
function c53701030.filter(c,e)
	return e:GetHandler():IsRelateToCard(c) and c:IsAbleToHand() and e:GetHandler():IsAbleToHand()
end
function c53701030.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(1-tp,1) then return end
	local g=Duel.GetDecktopGroup(1-tp,1)
	Duel.DisableShuffleCheck()
	Duel.Destroy(g,REASON_EFFECT)
	local trg=e:GetHandler():GetFlagEffect(53701000)
	e:GetHandler():RegisterFlagEffect(53701000,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53701000,trg))
	local nm=2
	if e:GetHandler():IsHasEffect(53701009) then nm=1 end
	local sg=Duel.GetMatchingGroup(c53701030.filter,tp,LOCATION_GRAVE,0,nil,e)
	if (trg+1)%nm==0 then
		e:GetHandler():ResetFlagEffect(53701000)
		if #sg>0 then
			Duel.Hint(HINT_CARD,0,53701030)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		end
	end
end
