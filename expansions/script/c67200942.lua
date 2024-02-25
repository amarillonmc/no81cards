--原初修正者 太一·庚辰
function c67200942.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c67200942.matfilter,3,4)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200942,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,67200942)
	e1:SetTarget(c67200942.thtg)
	e1:SetOperation(c67200942.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c67200942.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)	
end
function c67200942.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x67a) or (c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x67a))
end 
function c67200942.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true, true
end
function c67200942.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,67200941) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
--
function c67200942.thfilter(c)
	return not c:IsCode(67200942) and c:IsFaceupEx() and c:IsSetCard(0x67a) and c:IsAbleToHand()
end
function c67200942.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c67200942.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	if chk==0 then return g:GetCount()>=1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c67200942.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c67200942.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
	if Duel.SendtoHand(tg1,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tg1)
	end
end