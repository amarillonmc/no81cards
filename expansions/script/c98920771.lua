--追光☆姐妹-橘花之希波墨
local s,id,o=GetID()
function c98920771.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	c:RegisterEffect(e1)	
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c98920771.negcon)
	e2:SetOperation(c98920771.negop)
	c:RegisterEffect(e2)
	--spsummon from szone
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCost(s.spcost)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetHintTiming(0,TIMING_MAIN_END)
	e5:SetCondition(s.setcon)
	e5:SetTarget(s.settg)
	e5:SetOperation(s.setop)
	c:RegisterEffect(e5)
end
function c98920771.tfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsControler(tp) and c:IsOnField()
end
function c98920771.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return e:GetHandler():GetFlagEffect(98930771)==0 and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and g and g:IsExists(c98920771.tfilter,1,e:GetHandler(),tp)
		and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
end
function c98920771.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		e:GetHandler():RegisterFlagEffect(98930771,RESET_EVENT+RESETS_STANDARD,0,1)
		Duel.NegateEffect(ev)
	end
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(id)==0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x1c1,TYPES_EFFECT_TRAP_MONSTER,2000,2000,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.thfilter(c)
	return c:IsType(TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSetCard(0x1c1)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp) and not c:IsCode(id)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x1c1,TYPES_EFFECT_TRAP_MONSTER,2000,2000,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c98920771.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
		   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():IsCanBePlacedOnField() end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end