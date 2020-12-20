--苍白月下 纯真之眼
function c33711001.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c33711001.mfilter,5,3)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33711001,4))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_XYZ)
	e0:SetCondition(c33711001.spcon1)
	e0:SetOperation(c33711001.spop1)
	c:RegisterEffect(e0)  
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c33711001.imtg)
	e1:SetValue(c33711001.efilter)
	c:RegisterEffect(e1) 
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c33711001.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2) 
	--cannot release
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c33711001.rellimit)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33711001,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(c33711001.spcost)
	e4:SetTarget(c33711001.sptg)
	e4:SetOperation(c33711001.spop)
	c:RegisterEffect(e4)
	--leave field
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33711001,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c33711001.setcon)
	e5:SetTarget(c33711001.settg)
	e5:SetOperation(c33711001.setop)
	c:RegisterEffect(e5)
end
function c33711001.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function c33711001.ovfilter1(c,sc)
	return c:IsFaceup() and c:IsSetCard(0x440) and c:IsCanBeXyzMaterial(sc)
end
function c33711001.ovfilter(c,sc)
	return c:IsFaceup() and c:IsCode(33700033,33700051,33701072) and c:IsCanBeXyzMaterial(sc)
end
function c33711001.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c33711001.ovfilter,tp,LOCATION_MZONE,0,nil,c)>0
		and Duel.GetMatchingGroupCount(c33711001.ovfilter1,tp,LOCATION_MZONE,0,nil,c)>0
end
function c33711001.spzfilter(g,sc)
	return g:IsExists(c33711001.ovfilter,1,nil,sc) and g:IsExists(c33711001.ovfilter,1,nil,sc)
end
function c33711001.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c33711001.ovfilter,tp,LOCATION_MZONE,0,nil,c)
	local g2=Duel.GetMatchingGroup(c33711001.ovfilter1,tp,LOCATION_MZONE,0,nil,c)
	g1:Merge(g2)
	local sg=g1:SelectSubGroup(tp,c33711001.spzfilter,false,2,2,e:GetHandler())
	local og=Group.CreateGroup()
	for tc in aux.Next(sg) do
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(c,mg)
			end
			c:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c33711001.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c33711001.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c33711001.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsRelateToEffect(e) then
		if Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e0=Effect.CreateEffect(c)
			e0:SetCode(EFFECT_CHANGE_TYPE)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetReset(RESET_EVENT+0x1fe0000)
			e0:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			c:RegisterEffect(e0)
			--avoid damage
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetRange(LOCATION_SZONE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e2) 
		end
	end
		
end
function c33711001.imtg(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup() and c:IsLevel(5)
end
function c33711001.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c33711001.indtg(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup() and c:IsLevel(5)
end
function c33711001.rellimit(e,c,tp,sumtp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup() and c:IsLevel(5)
end
function c33711001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33711001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33711002,nil,0x4011,nil,nil,5,RACE_WARRIOR,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33711001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local atk=c:GetAttack()
		local def=c:GetDefense()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,33711002,0,0x4011,atk,def,5,RACE_WARRIOR,ATTRIBUTE_EARTH) then return end
		local token=Duel.CreateToken(tp,33711002)
		c:CreateRelation(token,RESET_EVENT+RESETS_STANDARD)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c33711001.tokenatk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c33711001.tokendef)
		token:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
end
function c33711001.tokenatk(e,c)
	return e:GetOwner():GetAttack()
end
function c33711001.tokendef(e,c)
	return e:GetOwner():GetDefense()
end