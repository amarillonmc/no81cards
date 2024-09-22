--方舟骑士-凯尔希
c29056009.named_with_Arknight=1
function c29056009.initial_effect(c)
	aux.AddCodeList(c,29065500,29065578)
--summon with no tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(51126152,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c29056009.ntcon)
	e0:SetOperation(c29056009.ntop)
	c:RegisterEffect(e0)
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
	c29056009.summon_effect=e1 
end
--search
function c29056009.thfilter(c)
	return (((c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))) or c:IsCode(29065578)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c29056009.amyfilter(c)
	return c:IsFaceup() and c:IsCode(29065500)
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
function c29056009.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c29056009.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1600)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end