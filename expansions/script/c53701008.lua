local m=53701008
local cm=_G["c"..m]
cm.name="惧轮 掠金客"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(cm.value)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.descon)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CUSTOM+53701033)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(cm.desop)
	c:RegisterEffect(e6)
end
function cm.spcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3530)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_MZONE,0,2,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_MZONE,0,1,1,nil,RACE_MACHINE)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function cm.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*250
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3530) and c:IsControler(tp) and c:IsAttackPos()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.desfilter1(c,mc)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsCode(53701009) and c:GetLinkedGroup():IsContains(mc)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(1-tp,1) then return end
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	Duel.DisableShuffleCheck()
	Duel.Destroy(g,REASON_EFFECT)
	local trg=e:GetHandler():GetFlagEffect(53701000)
	e:GetHandler():RegisterFlagEffect(53701000,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53701000,trg))
	local nm=3
	if e:GetHandler():IsHasEffect(53701009) then nm=2 end
	if (trg+1)%nm==0 then
		e:GetHandler():ResetFlagEffect(53701000)
		if Duel.IsPlayerCanDraw(tp,1) then
			Duel.Hint(HINT_CARD,0,m)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
