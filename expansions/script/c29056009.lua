--方舟骑士-凯尔希
c29056009.named_with_Arknight=1
function c29056009.initial_effect(c)
	aux.AddCodeList(c,29065500)
	--summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(6616912,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	c:RegisterEffect(e0)
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
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c29056009.reccon)
	e3:SetTarget(c29056009.rectg)
	e3:SetOperation(c29056009.recop)
	c:RegisterEffect(e3)
end
function c29056009.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c29056009.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local atk=e:GetHandler():GetTextAttack()
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c29056009.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c29056009.thfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29056009.filter(c)
	return c:IsFaceup() and c:IsCode(29065500)
end
function c29056009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29056009.thfilter,tp,LOCATION_DECK,0,1,nil) end
	--e:SetLabel(0)
	--if Duel.IsExistingMatchingCard(c29056009.filter,tp,LOCATION_MZONE,0,1,nil) then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29056009.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29056009.thfilter,tp,LOCATION_DECK,0,nil)
	if #g<=0 then return end
	local ct=1
	--if e:GetLabel()==1 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	res=Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
		if res>0 and not Duel.IsExistingMatchingCard(c29056009.filter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
end