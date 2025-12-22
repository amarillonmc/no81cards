--天斗辉巧-小熊流星=URS
function c98920437.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,98920437)
	 --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c98920437.efilter)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c98920437.sprcon)
	e2:SetOperation(c98920437.sprop)
	c:RegisterEffect(e2)
	 --negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98920437.discon)
	e3:SetOperation(c98920437.disop)
	c:RegisterEffect(e3)
	 --
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c98920437.valcheck)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c98920437.matcon)
	e5:SetOperation(c98920437.matop)
	c:RegisterEffect(e5)
	e4:SetLabelObject(e5)
end
function c98920437.mat_group_check(g)
	return g:GetSum(Card.GetAttack)>=4000
end
function c98920437.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
function c98920437.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98920437,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98920437,1))
end
function c98920437.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function c98920437.mnfilter(c,g)
	return g:IsExists(c98920437.mnfilter2,1,c,c)
end
function c98920437.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==1
end
function c98920437.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER)
		and g:IsExists(c98920437.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c98920437.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c98920437.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c98920437.fselect,2,2,tp,c)
end
function c98920437.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c98920437.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c98920437.fselect,false,2,2,tp,c)
	c:SetMaterial(tg)
	Duel.SendtoGrave(tg,REASON_COST)
end
function c98920437.csfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsLevelAbove(8)
end
function c98920437.efilter(e,te)
	local tc=te:GetOwner()
	return te:IsActiveType(TYPE_MONSTER) and te:IsActivated()
		and te:GetActivateLocation()==LOCATION_MZONE and tc:IsSummonLocation(LOCATION_EXTRA)
end
function c98920437.disfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function c98920437.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and e:GetHandler():GetFlagEffect(98920437)>0
		and e:GetHandler():GetFlagEffect(98930437)<=0
end
function c98920437.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(98920437,2)) then
		Duel.Hint(HINT_CARD,0,98920437)
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
		e:GetHandler():RegisterFlagEffect(98930437,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98920437,3))
	end
end
function c98920437.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function c98920437.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c98920437.lvfilter,nil,c)
	if (#fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2) or (mg:IsExists(c98920437.csfilter,1,nil)) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end