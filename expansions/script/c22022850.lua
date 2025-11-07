--灾厄征兆 梅露辛
function c22022850.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,22021730),1,1)
	c:EnableReviveLimit()
	--synchro effect
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(22022850,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCountLimit(1,22022850+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c22022850.sccon)
	e1:SetTarget(c22022850.sctarg)
	e1:SetOperation(c22022850.scop)
	c:RegisterEffect(e1) 
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022850,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22022850.discon)
	e2:SetCost(c22022850.cost)
	e2:SetTarget(c22022850.distg)
	e2:SetOperation(c22022850.disop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022850,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22022850)
	e3:SetCost(c22022850.spcost)
	e3:SetTarget(c22022850.sptg)
	e3:SetOperation(c22022850.spop)
	c:RegisterEffect(e3)
end
c22022850.material_type=TYPE_SYNCHRO 
function c22022850.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and rp==tp and re:GetHandler():IsCode(22021730)
end
function c22022850.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	local mg=Duel.GetMatchingGroup(function(c) return c:IsCanBeSynchroMaterial() and c:IsType(TYPE_MONSTER) end,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return e:GetHandler():IsSynchroSummonable(nil,mg,1,99) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22022850.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(function(c) return c:IsCanBeSynchroMaterial() and c:IsType(TYPE_MONSTER) end,tp,LOCATION_MZONE,0,nil)  
	if c:IsSynchroSummonable(nil,mg,1,99) then 
		Duel.SynchroSummon(tp,c,nil,mg,1,99)  
	end
end
function c22022850.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c22022850.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c22022850.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c22022850.spfilter(c,e,tp)
	return c:IsCode(22021730) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22022850.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c22022850.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1621413,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c22022850.cfilter(c,tp)
	return c:IsFaceup() and (c:IsCode(22021730) or c:IsRace(RACE_DRAGON)) and Duel.GetMZoneCount(tp,c)>0
end
function c22022850.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(REASON_COST,tp,c22022850.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,c22022850.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c22022850.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22022850.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
