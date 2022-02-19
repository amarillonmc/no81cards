--灵兽训练师 小楓和小南
function c33200105.initial_effect(c)
	c:SetUniqueOnField(1,1,33200105)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c33200105.lcheck)  
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,33200105)
	e1:SetCondition(c33200105.smcon)
	e1:SetTarget(c33200105.smtg)
	e1:SetOperation(c33200105.smop)
	c:RegisterEffect(e1)  
	--spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c33200105.indtg)
	e2:SetValue(c33200105.efilter)
	c:RegisterEffect(e2)
	--cannot be battle traget
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	--cant link
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e5)	
end

function c33200105.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x324)
end

--e1
function c33200105.smcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c33200105.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x324) and Duel.IsExistingMatchingCard(c33200105.filter2,tp,LOCATION_DECK,0,1,nil,e,c:GetCode())
end
function c33200105.filter2(c,e,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c33200105.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c33200105.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33200105,0))
	local g=Duel.SelectTarget(tp,c33200105.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33200105.smop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33200105.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tc:GetOriginalCode())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e2
function c33200105.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x324)
end
function c33200105.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end