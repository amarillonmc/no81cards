--AKA-悲歌的斯卡蒂-浊心
function c82568045.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,82568048),LOCATION_MZONE)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c82568045.ffilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x825),1,63,true,true)
	--increase level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82568045,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c82568045.lvcon)
	e1:SetOperation(c82568045.lvop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c82568045.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	--P set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c82568045.pentg)
	e2:SetOperation(c82568045.penop)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--atk down
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82568045,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c82568045.atkcon0)
	e4:SetTarget(c82568045.target)
	e4:SetOperation(c82568045.activate)
	e4:SetValue(c82568045.rdval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCondition(c82568045.atkcon)
	c:RegisterEffect(e5)
	--atkup
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCondition(c82568045.atkcon3)
	e6:SetTarget(c82568045.aufilter)
	e6:SetValue(c82568045.val)
	c:RegisterEffect(e6)	
	--battle target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_PZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e7:SetValue(c82568045.sbfilter)
	c:RegisterEffect(e7)
end
function c82568045.atkcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82568045.sbfilter2,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()~=e:GetHandler():GetControler()
end
function c82568045.val(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local scl=c:GetLeftScale()
	return scl*100
end
function c82568045.sbfilter2(c)
	return c:IsCode(82568048) 
end
function c82568045.sbfilter(e,c)
	return c:IsCode(82568048) 
end
function c82568045.aufilter(e,c)
	return not c:IsCode(82568048) and c:IsFaceup()
end
function c82568045.filter(c)
	return c:IsFaceup() 
end
function c82568045.rdval(e)
	return e:GetHandler():GetLeftScale()*200
end
function c82568045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c82568045.filter,tp,0,LOCATION_MZONE,nil)
	local nsg=sg:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568045.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,nsg,tp,0)
end
function c82568045.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82568045.filter,tp,0,LOCATION_MZONE,nil)
	local atk=c82568045.rdval(e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	if not c:IsRelateToEffect(e) then return false end
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c82568045.atkcon0(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c82568045.akafilter,tp,LOCATION_MZONE,0,1,nil)
end
function c82568045.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82568045.akafilter,tp,LOCATION_MZONE,0,1,nil)
end
function c82568045.akafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9825)
end
function c82568045.valcheck(e,c)
	local val=c:GetMaterial():GetCount()
	e:GetLabelObject():SetLabel(val)
end
function c82568045.ffilter(c)
	return c:IsFusionSetCard(0x825) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c82568045.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function c82568045.lvop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()*3
	if lv>12 then lv=12 end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end	
function c82568045.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	local lv=e:GetHandler():GetLevel()
	e:SetLabel(lv)
end
function c82568045.penop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
	if c:GetLeftScale()>=7  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82568048,0,0x4011,1000,1000,3,RACE_DEVINE,ATTRIBUTE_WATER) and Duel.SelectYesNo(tp,aux.Stringid(82568045,0)) then 
	local token=Duel.CreateToken(tp,82568048)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
	local g=Duel.GetOperatedGroup()
	local sb=g:GetFirst()
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c82568045.sdcon)
	sb:RegisterEffect(e4)
	end
	end
	end
end
function c82568045.SKDfilter(c)
	return c:IsCode(82568045) and c:IsFaceup()
end
function c82568045.sdcon(e)
	return not Duel.IsExistingMatchingCard(c82568045.SKDfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end