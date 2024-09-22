--领主的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98346588,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98346588.spcon)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98346590,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetTarget(c98346588.sptg)
	e2:SetOperation(c98346588.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98346588,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+o)
	e3:SetCost(c98346588.descost)
	e3:SetTarget(c98346588.destg)
	e3:SetOperation(c98346588.desop)
	c:RegisterEffect(e3)
end
function c98346588.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)
end
function c98346588.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98346590,0xaf7,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,5,RACE_WARRIOR,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c98346588.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98346590,0xaf7,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,5,RACE_WARRIOR,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,98346590)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
		token:RegisterFlagEffect(98346588,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c98346588.indecon)
		e1:SetValue(500)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c98346588.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		--
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(c98346588.indecon)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(1)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e4)
	end
end
function c98346588.splimit(e,c)
	return not c:IsSetCard(0xaf7)
end
function c98346588.indefilter(c)
	return c:GetFlagEffect(98346588)>0
end
function c98346588.indecon(e)
	return Duel.IsExistingMatchingCard(c98346588.indefilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c98346588.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0
		and Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,98346590) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,98346590)
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
end
function c98346588.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>1
		and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98346588.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end