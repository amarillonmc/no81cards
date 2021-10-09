--骑士时刻·盖茨-Ghost装甲
function c9981157.initial_effect(c)
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981157,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c9981157.spcon)
	e1:SetTarget(c9981157.sptg)
	e1:SetOperation(c9981157.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981157,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c9981157.tg)
	e1:SetOperation(c9981157.op)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981157,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetCondition(c9981157.descon)
	e3:SetTarget(c9981157.destg)
	e3:SetOperation(c9981157.desop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981157.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981157.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981157,2))
end
function c9981157.spfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x6bc3)
end
function c9981157.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9981157.spfilter,1,nil,tp)
end
function c9981157.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9981157.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local atk=c:GetBaseAttack()
		local def=c:GetBaseDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(def/2)
		c:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function c9981157.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9981157,1))
	e:SetLabel(Duel.AnnounceLevel(tp,1,8,lv))
end
function c9981157.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c9981157.descfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bc3)
end
function c9981157.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9981157.descfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c9981157.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and t~=nil end
	Duel.SetTargetCard(t)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,t,1,0,0)
end
function c9981157.desop(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFirstTarget()
	if t:IsRelateToBattle() then
		Duel.Destroy(t,REASON_EFFECT)
	end
end