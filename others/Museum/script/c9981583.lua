--光芒方界神  红莲之挪婆
function c9981583.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c9981583.spcon)
	e2:SetOperation(c9981583.spop)
	c:RegisterEffect(e2)
--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9981583.efilter)
	c:RegisterEffect(e1)
 --control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9981583,0))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c9981583.cttg)
	e4:SetOperation(c9981583.ctop)
	c:RegisterEffect(e4)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981583,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9981583.thtg)
	e3:SetOperation(c9981583.thop)
	c:RegisterEffect(e3)
	 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981583.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981583.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981583,0))
end 
function c9981583.spcfilter(c)
	return c:IsSetCard(0xe3) and not c:IsPublic()
end
function c9981583.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local hg=Duel.GetMatchingGroup(c9981583.spcfilter,tp,LOCATION_HAND,0,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and hg:GetClassCount(Card.GetCode)>=3
end
function c9981583.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local hg=Duel.GetMatchingGroup(c9981583.spcfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rg=hg:SelectSubGroup(tp,aux.dncheck,false,3,3)
	Duel.ConfirmCards(1-tp,rg)
	Duel.ShuffleHand(tp)
end
function c9981583.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c9981583.ctfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c9981583.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c9981583.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9981583.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c9981583.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c9981583.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981583,0))
end
function c9981583.thfilter(c)
	return c:IsSetCard(0xe3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9981583.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981583.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9981583.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9981583.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end