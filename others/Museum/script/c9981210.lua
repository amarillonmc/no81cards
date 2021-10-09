--飞电智能·Zero-One-升华蝗虫
function c9981210.initial_effect(c)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981210,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c9981210.ntcon)
	c:RegisterEffect(e2)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981210,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9981210)
	e1:SetCondition(c9981210.stcon)
	e1:SetTarget(c9981210.sttg)
	e1:SetOperation(c9981210.stop)
	c:RegisterEffect(e1)
	--Special Summon (deck)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981210,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,99812100)
	e2:SetCondition(c9981210.spcon2)
	e2:SetTarget(c9981210.sptg2)
	e2:SetOperation(c9981210.spop2)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981210.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981210.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981210,0))
end
function c9981210.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5)
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c9981210.stcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and re:GetHandler()~=e:GetHandler()
end
function c9981210.stfilter(c)
	return c:IsSetCard(0x3bc9,0x5bc9) and c:IsType(TYPE_MONSTER) and c:IsSSetable()
end
function c9981210.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981210.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c9981210.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9981210.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local ct=Duel.SSet(tp,g)
		if ct~=0 then
			Duel.ConfirmCards(1-tp,g)
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabelObject(tc)
			e1:SetCondition(c9981210.descon)
			e1:SetOperation(c9981210.desop)
			if Duel.GetTurnPlayer()==1-tp then
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
				e1:SetValue(Duel.GetTurnCount())
				tc:RegisterFlagEffect(9981210,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,2)
			else
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				e1:SetValue(0)
				tc:RegisterFlagEffect(9981210,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
			end
			Duel.RegisterEffect(e1,tp)
		end
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981210,2))
end
function c9981210.descon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=1-tp or Duel.GetTurnCount()==e:GetValue() then return false end
	return e:GetLabelObject():GetFlagEffect(9981210)~=0
end
function c9981210.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c9981210.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9981210.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3bc9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c9981210.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9981210.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9981210.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981210.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
