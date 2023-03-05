--巨大战舰 泡核
function c98920420.initial_effect(c)
	c:EnableCounterPermit(0x1f)
	 --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c98920420.matfilter,1,1) 
--cannot be link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920420,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98920420.thcon)
	e1:SetOperation(c98920420.addc)
	c:RegisterEffect(e1)
--atk up
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c98920420.atkval)
	c:RegisterEffect(e6)
--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
--remove counter
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920420,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetCondition(aux.dsercon)
	e5:SetTarget(c98920420.rcttg)
	e5:SetOperation(c98920420.rctop)
	c:RegisterEffect(e5)
--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920420,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c98920420.drcost)
	e4:SetCondition(c98920420.spcon)
	e4:SetTarget(c98920420.sptg)
	e4:SetOperation(c98920420.spop)
	c:RegisterEffect(e4)
end
function c98920420.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x1f,1,REASON_COST) end
	c:RemoveCounter(tp,0x1f,1,REASON_COST)
end
function c98920420.matfilter(c)
	return c:IsLevelAbove(5) and c:IsLinkRace(RACE_MACHINE)
end
function c98920420.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98920420.matfilters(c)
	return c:IsSetCard(0x15) and c:GetOriginalLevel()>=0
end
function c98920420.addc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial():Filter(c98920420.matfilters,nil)
	local s=g:GetSum(Card.GetOriginalLevel)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1f,s)
	end
end
function c98920420.atkval(e,c)
	return e:GetHandler():GetCounter(0x1f)*400
end
function c98920420.rcttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not e:GetHandler():IsCanRemoveCounter(tp,0x1f,1,REASON_EFFECT) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function c98920420.rctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if c:IsCanRemoveCounter(tp,0x1f,1,REASON_EFFECT) then
			c:RemoveCounter(tp,0x1f,1,REASON_EFFECT)
		else
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
function c98920420.filter(c,e,tp)
	return c:IsSetCard(0x15) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920420.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsType(TYPE_LINK) and c:GetLinkedGroupCount()==0 and Duel.GetTurnPlayer()==tp
end
function c98920420.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920420.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920420.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g=Duel.SelectMatchingCard(tp,c98920420.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end