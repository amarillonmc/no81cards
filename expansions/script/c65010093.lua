--星光歌剧 西条克洛迪娜Revue
function c65010093.initial_effect(c)
	--summon with 1 tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(65010093,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c65010093.otcon)
	e0:SetOperation(c65010093.otop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabelObject(e4)
	e2:SetCondition(c65010093.eqcon)
	e2:SetTarget(c65010093.eqtg)
	e2:SetOperation(c65010093.eqop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c65010093.negcon)
	e3:SetTarget(c65010093.negtg)
	e3:SetOperation(c65010093.negop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c65010093.atkcon)
	e4:SetValue(c65010093.atkval)
	c:RegisterEffect(e4)
end
function c65010093.otfilter(c)
	return c:IsSetCard(0x9da0)
end
function c65010093.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c65010093.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c65010093.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c65010093.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c65010093.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c65010093.eqfil(c)
	return c:IsSetCard(0x9da0) and c:IsType(TYPE_MONSTER) 
end
function c65010093.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010093.eqfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function c65010093.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c65010093.eqfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,c65010093.eqfil,tp,LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		local c=e:GetHandler()
		Duel.Equip(tp,tc,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c65010093.eqlimit)
		tc:RegisterEffect(e1)
		--atkup
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetRange(LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetLabelObject(tc)
		e4:SetCondition(c65010093.atkcon)
		e4:SetValue(c65010093.atkval)
		c:RegisterEffect(e4)
	end
end
function c65010093.eqlimit(e,c)
	return e:GetOwner()==c
end
function c65010093.atkcon(e,c)
	return e:GetLabelObject()~=nil
end
function c65010093.atkval(e,c)
	local tc=e:GetLabelObject()
	local lv=tc:GetLevel()
	return lv*200
end
function c65010093.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and Duel.GetTurnPlayer()~=tp
end
function c65010093.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,65010094,65010095) then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	end
end
function c65010093.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,65010094,65010095) and re:GetHandler():IsRelateToEffect(re) and Duel.SelectYesNo(tp,aux.Stringid(65010093,1)) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end