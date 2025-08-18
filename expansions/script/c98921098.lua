--异次元的虹彩
function c98921098.initial_effect(c)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c98921098.settg)
	e2:SetOperation(c98921098.setop)
	c:RegisterEffect(e2)	
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921098,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,98921098+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c98921098.con)
	e1:SetTarget(c98921098.target)
	e1:SetOperation(c98921098.operation)
	c:RegisterEffect(e1)
end
function c98921098.setfilter(c)
	return c:IsCode(49600724) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c98921098.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921098.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c98921098.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c98921098.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
function c98921098.con(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) and rc:IsType(TYPE_TRAP)
end
function c98921098.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local aat=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL&~e:GetHandler():GetAttribute())
	e:SetLabel(aat)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c98921098.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		--remove
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTarget(c98921098.rmtg)
		e2:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
		e2:SetValue(LOCATION_REMOVED)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)		
		c:RegisterEffect(e2)
	 	--
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(98921098)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e3:SetTargetRange(0xff,0xff)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)		
		e3:SetTarget(c98921098.checktg)
		c:RegisterEffect(e3)
	end
end
function c98921098.rmtg(e,c)
	return c:GetOriginalType()&TYPE_MONSTER>0 and not c:IsLocation(LOCATION_OVERLAY) and not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetAttribute()==e:GetHandler():GetAttribute()
end
--
function c98921098.checktg(e,c)
	return not c:IsPublic()
end