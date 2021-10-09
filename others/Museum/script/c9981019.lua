--黑魔术魔女·玛姬纱
function c9981019.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,c9981019.mfilter,1,1)
	c:EnableReviveLimit()
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(46986414)
	c:RegisterEffect(e1)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c9981019.etcon)
	e3:SetTarget(c9981019.etarget)
	e3:SetValue(c9981019.efilter)
	c:RegisterEffect(e3)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981019,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9981019)
	e1:SetCondition(c9981019.thcon1)
	e1:SetTarget(c9981019.thtg1)
	e1:SetOperation(c9981019.thop1)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981019.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
c9981019.card_code_list={46986414,38033121}
function c9981019.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981019,0))
end 
function c9981019.mfilter(c)
	return c:IsLevelAbove(5) and c:IsLinkSetCard(0x10a2)
end
function c9981019.etcon(e)
	return e:GetHandler():GetSequence()>4
end
function c9981019.etarget(e,c)
	return c:IsSetCard(0x10a2)
end
function c9981019.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c9981019.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9981019.thfilter1(c)
	return ((aux.IsCodeListed(c,46986414) or aux.IsCodeListed(c,38033121))
		and c:IsType(TYPE_SPELL+TYPE_TRAP)) or c:IsCode(1784686)and c:IsAbleToHand()
end
function c9981019.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981019.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9981019.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9981019.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end