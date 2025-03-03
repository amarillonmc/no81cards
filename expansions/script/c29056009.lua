--方舟骑士-凯尔希
function c29056009.initial_effect(c)
	aux.AddCodeList(c,29065500,29065578)
--summon with no tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(51126152,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c29056009.ntcon)
	--c:RegisterEffect(e0)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(39392286,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,29056009)
	e1:SetTarget(c29056009.thtg)
	e1:SetOperation(c29056009.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--chenweiduixiang sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29056009,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,29056010)
	e3:SetCondition(c29056009.spcon1)
	e3:SetTarget(c29056009.sptg)
	e3:SetOperation(c29056009.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCondition(c29056009.spcon2)
	c:RegisterEffect(e4)
	c29056009.summon_effect=e1 
end
	--chenweiduixiang sp
function c29056009.tgfilter(c,e)
	return c:IsLocation(LOCATION_ONFIELD) and c:GetControler()==e:GetHandler():GetControler()
end
function c29056009.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29056009.tgfilter,1,nil,e)
end
function c29056009.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function c29056009.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsCode(29065578) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29056009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c29056009.spfilter,tp,0x33,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x33)
end
function c29056009.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29056009.spfilter,tp,0x33,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
--search
function c29056009.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c29056009.amyfilter(c)
	return c:IsFaceup() and (c:IsCode(29065500) or c:IsCode(29065502))
end
function c29056009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29056009.thfilter,tp,LOCATION_DECK,0,1,nil) end
	e:SetLabel(0)
	if Duel.IsExistingMatchingCard(c29056009.amyfilter,tp,LOCATION_ONFIELD,0,1,nil) then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29056009.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29056009.thfilter,tp,LOCATION_DECK,0,nil)
	if #g<=0 then return end
	local ct=1
	if e:GetLabel()==1 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
end
--summon with no tribute
function c29056009.cfilter(c)
	return not c:IsSetCard(0x87af) and c:IsType(TYPE_EFFECT)
end
function c29056009.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c29056009.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end