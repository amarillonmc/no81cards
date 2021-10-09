--疾速骑士超Mashin Chaser
function c9980904.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,c9980904.ffilter1,aux.FilterBoolFunction(Card.IsFusionSetCard,0xbca),2,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980904.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c9980904.eqtg)
	e1:SetOperation(c9980904.eqop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980904,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c9980904.eqtg)
	e2:SetOperation(c9980904.eqop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c9980904.eqcon)
	e3:SetValue(c9980904.efilter)
	c:RegisterEffect(e3)
	--special summon equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980904,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetTarget(c9980904.sptg)
	e2:SetOperation(c9980904.spop)
	c:RegisterEffect(e2)
end
function c9980904.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980904,0))
end
function c9980904.ffilter1(c)
	return c:IsCode(9980903,9980905)
end
function c9980904.filter(c)
	return c:IsSetCard(0xbca) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9980904.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9980904.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c9980904.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c9980904.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,c)
	local tc=g:GetFirst()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,true) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9980904.eqlimit)
		tc:RegisterEffect(e1)
		local atk=tc:GetBaseAttack()
		if atk>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(atk)
			tc:RegisterEffect(e2)
		end
	else Duel.SendtoGrave(tc,REASON_RULE) end
end
function c9980904.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9980904.eqcon(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg:GetCount()>0
end
function c9980904.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c9980904.spfilter(c,e,tp,ec)
	return c:GetFlagEffect(9980904)~=0 and c:GetEquipTarget()==ec and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980904.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c9980904.spfilter(chkc,e,tp,c) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9980904.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9980904.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9980904.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
