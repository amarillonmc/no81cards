--方舟骑士-凯尔希
c29056009.named_with_Arknight=1
function c29056009.initial_effect(c)
	aux.AddCodeList(c,29065500)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29056009,0))
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
end
function c29056009.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and (Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x10ae,2,REASON_COST) or (Duel.GetFlagEffect(tp,29096814)==1 and Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x10ae,1,REASON_COST)))
end
function c29056009.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetFlagEffect(tp,29096814)==1 then
	Duel.ResetFlagEffect(tp,29096814)
	Duel.RemoveCounter(tp,1,0,0x10ae,1,REASON_RULE)
	else
	Duel.RemoveCounter(tp,1,0,0x10ae,2,REASON_RULE)
	end
end
function c29056009.thfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29056009.filter(c)
	return c:IsFaceup() and c:IsCode(29065500)
end
function c29056009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29056009.thfilter,tp,LOCATION_DECK,0,1,nil) end
	e:SetLabel(0)
	if Duel.IsExistingMatchingCard(c29056009.filter,tp,LOCATION_MZONE,0,1,nil) then e:SetLabel(1) end
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