--最初的幻想
function c60150520.initial_effect(c)
	c:SetUniqueOnField(1,1,60150520)
	--xyz summon
	aux.AddXyzProcedure(c,c60150520.mfilter,9,9)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150520,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60150520.atkcon)
	e1:SetTarget(c60150520.tdtg)
	e1:SetOperation(c60150520.tdop)
	c:RegisterEffect(e1)
	--indes
	--local e2=Effect.CreateEffect(c)
   -- e2:SetType(EFFECT_TYPE_SINGLE)
	--e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	--e2:SetValue(c60150520.indval)
	--c:RegisterEffect(e2)
	--immune
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_SINGLE)
	--e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCode(EFFECT_IMMUNE_EFFECT)
	--e3:SetValue(c60150520.efilter)
	--c:RegisterEffect(e3)
	--素材效果
	--remove
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e11:SetTargetRange(0xff,0xff)
	e11:SetValue(LOCATION_DECKBOT)
	e11:SetCondition(c60150520.condition)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CANNOT_REMOVE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetTargetRange(1,1)
	e12:SetCondition(c60150520.condition)
	c:RegisterEffect(e12)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(30459350)
	e13:SetRange(LOCATION_MZONE)
	e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e13:SetTargetRange(1,1)
	e13:SetCondition(c60150520.condition)
	c:RegisterEffect(e13)
	--Special Summon
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(60150520,1))
	e14:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e14:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e14:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e14:SetCode(EVENT_LEAVE_FIELD)
	e14:SetCountLimit(1,60150520)
	e14:SetCondition(c60150520.sumcon)
	e14:SetTarget(c60150520.sumtg)
	e14:SetOperation(c60150520.sumop)
	c:RegisterEffect(e14)
	--[[spsummon limit
	local e111=Effect.CreateEffect(c)
	e111:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e111:SetType(EFFECT_TYPE_SINGLE)
	e111:SetCode(EFFECT_SPSUMMON_CONDITION)
	e111:SetValue(c60150520.splimit)
	c:RegisterEffect(e111)]]
end
function c60150520.mfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60150520.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c60150520.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60150520.indval(e,c)
	return c:IsFaceup() and (c:GetAttack()~=c:GetBaseAttack() or c:GetDefense()~=c:GetBaseDefense())
end
function c60150520.efilter(e,te)
	if te:IsActiveType(TYPE_MONSTER) then
		local ec=te:GetOwner()
		return (ec:GetAttack()~=ec:GetBaseAttack() or ec:GetDefense()~=ec:GetBaseDefense()) and not ec:IsCode(60150520)
	end
end
function c60150520.filter(c,e,tp)
	return c:GetRank()<=10 and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150520.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150520.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150520.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60150520.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60150520.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60150520.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_REMOVED+LOCATION_GRAVE)
	Duel.SetChainLimit(aux.FALSE)
end
function c60150520.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(g:GetCount()*300)
		c:RegisterEffect(e1)
	end
end
function c60150520.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60150519)
end