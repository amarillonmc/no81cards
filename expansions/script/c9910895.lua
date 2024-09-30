--万千生灵 血脉交织的王女
function c9910895.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,9910886,c9910895.matfilter,2,63,true,true)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c9910895.atkcon)
	e1:SetValue(c9910895.atkval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c9910895.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--defup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(c9910895.atkcon)
	e3:SetValue(c9910895.atkval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c9910895.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c9910895.immcon)
	e5:SetOperation(c9910895.immop)
	c:RegisterEffect(e5)
	--race
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetOperation(c9910895.raop)
	c:RegisterEffect(e3)
	--tograve
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(9910895,0))
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_REMOVE)
	e7:SetCountLimit(1)
	e7:SetCondition(c9910895.tgcon)
	e7:SetTarget(c9910895.tgtg)
	e7:SetOperation(c9910895.tgop)
	c:RegisterEffect(e7)
end
function c9910895.matfilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsRace,1,c,c:GetRace())
end
function c9910895.atkcon(e)
	return e:GetHandler():GetFlagEffect(9910871)>0
end
function c9910895.valcheck(e,c)
	local ct=c:GetMaterialCount()
	e:GetLabelObject():SetLabel(ct)
end
function c9910895.immcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsCode(9910871) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c9910895.atkval(e,c)
	return e:GetLabel()*500
end
function c9910895.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910895,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9910895.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c9910895.efilter(e,te)
	return e:GetOwner():GetBattledGroupCount()==0 and te:GetOwner()~=e:GetOwner()
end
function c9910895.raop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	local wg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	local wbc=wg:GetFirst()
	local race=0
	while wbc do
		race=race|wbc:GetOriginalRace()
		wbc=wg:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetValue(race)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c9910895.remfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c9910895.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910895.remfilter,1,nil)
end
function c9910895.tgfilter(c,tp)
	local race=c:GetRace()
	return aux.IsCodeListed(c,9910871) and c:IsType(TYPE_MONSTER) and race>0 and c:IsAbleToGrave()
		and not Duel.IsExistingMatchingCard(c9910895.filter1,tp,LOCATION_REMOVED,0,1,nil,race)
end
function c9910895.filter1(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function c9910895.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910895.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9910895.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910895.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
