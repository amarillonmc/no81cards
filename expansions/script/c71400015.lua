--幻异梦境-梦湖回廊
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400015.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400015,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c71400015.target1)
	e1:SetOperation(c71400015.operation1)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400015,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c71400015.target2)
	e2:SetOperation(c71400015.operation2)
	c:RegisterEffect(e2)
	--self to deck & activate field
	yume.AddYumeFieldGlobal(c,71400015,1)
end
function c71400015.filter1(c)
	return c:IsSetCard(0xe714) and c:IsAbleToHand()
end
function c71400015.filter1a(c)
	return c:IsSetCard(0x714) and (c:IsType(TYPE_TUNER) or c:IsAttribute(ATTRIBUTE_WATER)) and c:IsLevelAbove(1) and c:IsFaceup()
end
function c71400015.filter1b(c)
	return c:IsSetCard(0xe714) and c:IsAbleToGrave()
end
function c71400015.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71400015.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71400015.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c71400015.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function c71400015.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(c71400015.filter1a,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c71400015.filter1b,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(71400015,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c71400015.filter1b,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c71400015.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local mcount=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
	if chk==0 then return mcount>0 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,mcount*300)
end
function c71400015.operation2(e,tp,eg,ep,ev,re,r,rp)
	local mcount=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
	if mcount>0 then
		Duel.Recover(tp,mcount*300,REASON_EFFECT)
	end
end