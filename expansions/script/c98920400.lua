--凶导之白烙印
function c98920400.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCode(EFFECT_SPSUMMON_CONDITION)
	e10:SetValue(c98920400.splimit)
	c:RegisterEffect(e10)
--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920400,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c98920400.sptg)
	e2:SetOperation(c98920400.spop)
	c:RegisterEffect(e2)
--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920400,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98920400.discon)
	e1:SetOperation(c98920400.desop)
	c:RegisterEffect(e1)
 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c98920400.valcheck)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
--cannot be target/effect indestructable
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE)
	e20:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e20:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e20:SetRange(LOCATION_MZONE)
	e20:SetCondition(c98920400.indcon)
	e20:SetValue(aux.indoval)
	c:RegisterEffect(e20)
	local e30=e20:Clone()
	e30:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e30:SetValue(aux.tgoval)
	c:RegisterEffect(e30)
end
function c98920400.lvplus(c)
	if c:GetLevel()>=1 then return c:GetLevel() elseif c:GetRank()>=1 then return c:GetRank() elseif c:GetLink()>=1 then return c:GetLink() else return 0 end
end
function c98920400.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x145)
end
function c98920400.rmfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c98920400.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
		local mg2=Duel.GetMatchingGroup(c98920400.rmfilter,tp,0,LOCATION_MZONE,nil,e)
		mg1:Merge(mg2)
		return Duel.IsExistingMatchingCard(c98920400.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c98920400.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local mg=Duel.GetReleaseGroup(tp,true)
	local mg2=Duel.GetMatchingGroup(c98920400.rmfilter,tp,0,LOCATION_MZONE,nil,e)
	mg:Merge(mg2)
	local ft=Duel.GetMZoneCount(tp)
	if tc then
		mg=mg:Filter(Card.IsAbleToGrave,tc,tc)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,c98920400.lvplus,10,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c98920400.rmfilter1,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,c98920400.lvplus,10,tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		e:SetLabel(mat:GetCount())
		if not tc:IsRelateToEffect(e) then return end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c98920400.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c98920400.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98920400.splimit1)
	Duel.RegisterEffect(e1,tp)
end
function c98920400.splimit1(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c98920400.valcheck(e,c,tp)
	local tp=e:GetOwner():GetControler()
	local g=c:GetMaterial()
	if g:FilterCount(Card.IsControler,nil,tp)==#g then
		e:GetLabelObject():SetLabel(0)
	else
		e:GetLabelObject():SetLabel(1)
	end
end
function c98920400.thfilter(c)
	return c:IsSetCard(0x145,0x164) and c:IsType(TYPE_MONSTER)
end
function c98920400.indcon(e)
	return ep==tp and Duel.IsExistingMatchingCard(c98920400.thfilter,tp,LOCATION_GRAVE,0,1,nil)
end
