--搜查官 米雪儿·李
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	MTC.StrinovaPUS(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE+LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_XMATERIAL)
	e3:SetCountLimit(1,m+10000000)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.tg)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	
	MTC.StrinovaChangeZone(c,cm.czop)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.fil(c,e,tp)
	return c:IsLevel(4) and ((c:IsLocation(LOCATION_HAND) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) or (c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and c:IsAbleToHand())) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_HAND+LOCATION_SZONE,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_SZONE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.fil,tp,LOCATION_HAND+LOCATION_SZONE,0,c,e,tp)
	if #g==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local pzone=LOCATION_MZONE
	if c:IsLocation(LOCATION_MZONE) then pzone=LOCATION_SZONE end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,c,e,tp):GetFirst()
	
	if tc:IsLocation(LOCATION_SZONE) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
	if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,pzone)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) and Duel.MoveToField(c,tp,tp,pzone,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetCountLimit(1)
		e2:SetValue(cm.indct)
		c:RegisterEffect(e2)
	end
end
function cm.indct(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function cm.czfil(c)
	return c:IsSetCard(0x9623) and c:IsType(TYPE_MONSTER) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.czop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if Duel.IsExistingMatchingCard(cm.czfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.czfil,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end