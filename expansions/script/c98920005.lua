--迅捷松鼠
function c98920005.initial_effect(c)
		--link summon
	aux.AddLinkProcedure(c,nil,2,2,c98920005.lcheck)
	c:EnableReviveLimit()	
		--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(0,LOCATION_MZONE)
	e0:SetValue(c98920005.matval)
	c:RegisterEffect(e0)
 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920005,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98920005)
	e1:SetCondition(c98920005.thcon)
	e1:SetTarget(c98920005.thtg)
	e1:SetOperation(c98920005.thop)
	c:RegisterEffect(e1)  
  --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920005,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98930005)
	e3:SetCondition(c98920005.spcon)
	e3:SetTarget(c98920005.sptg)
	e3:SetOperation(c98920005.spop)
	c:RegisterEffect(e3)
end
function c98920005.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(Card.IsControler,2,nil,1-tp) and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function c98920005.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==1
end
function c98920005.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98920005.thfilter(c)
	return c:IsLevel(2) and (c:IsAttribute(ATTRIBUTE_EARTH) or c:IsAttribute(ATTRIBUTE_WATER)) and c:IsAbleToHand()
end
function c98920005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920005.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920005.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920005.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE)
		or (c:IsReason(REASON_DESTROY) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp )
end
function c98920005.spfilter(c,e,tp)
	return c:IsSetCard(0x78) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920005.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920005.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920005.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c98920005.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsSummonPlayer(tp) and tc:IsCode(e:GetLabel()) then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end