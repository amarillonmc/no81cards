--方舟骑士深层归还
c29065511.named_with_Arknight=1
function c29065511.initial_effect(c)
	aux.AddCodeList(c,29065500)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065511,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,29065511)
	e2:SetTarget(c29065511.thtg)
	e2:SetOperation(c29065511.thop)
	c:RegisterEffect(e2)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c29065511.target)
	e1:SetValue(c29065511.indct)
	c:RegisterEffect(e1)
end
function c29065511.tdfil(c)
	return c:IsAbleToHand() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065511.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_NORMAL) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c29065511.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetMatchingGroupCount(c29065511.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)>=1) or (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065500) and Duel.IsExistingMatchingCard(c29065511.spfil,tp,LOCATION_MZONE,0,1,nil,e,tp)) end
	if (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065500) and Duel.IsExistingMatchingCard(c29065511.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)) and Duel.SelectYesNo(tp,aux.Stringid(29065511,0)) then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,tp,0)
	e:SetLabel(0)
	else
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,tp,0)
	e:SetLabel(1)
	end 
end
function c29065511.thop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
	if Duel.GetMatchingGroupCount(c29065511.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)>0 then
	local tc=Duel.SelectMatchingCard(tp,c29065511.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)  
	end
	else
	local g=Duel.GetMatchingGroup(c29065511.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>=1 then
	local xg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(xg,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end
function c29065511.target(e,c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065511.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end