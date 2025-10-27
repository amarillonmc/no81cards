--传说之龙
function c11185325.initial_effect(c)
	c:SetSPSummonOnce(11185325)
	aux.AddCodeList(c,0x452)
	c:EnableCounterPermit(0x452)
	c:EnableReviveLimit()
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c11185325.hspcon)
	e0:SetTarget(c11185325.hsptg)
	e0:SetOperation(c11185325.hspop)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11185325)
	e1:SetTarget(c11185325.thtg)
	e1:SetOperation(c11185325.thop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11185325+1)
	e2:SetTarget(c11185325.countertg)
	e2:SetOperation(c11185325.counterop)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetValue(c11185325.tnval)
	c:RegisterEffect(e3)
end
function c11185325.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c11185325.hspfilter(c,tp,sc)
	return aux.IsCodeListed(c,0x452) and c:IsFaceup()
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c11185325.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroupEx(c:GetControler(),c11185325.hspfilter,1,REASON_SPSUMMON,false,nil,c:GetControler(),c)
end
function c11185325.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c11185325.hspfilter,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c11185325.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	Duel.Release(tc,REASON_SPSUMMON)
end
function c11185325.thfilter(c)
	return aux.IsCodeListed(c,0x452) and c:IsAbleToHand()
end
function c11185325.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185325.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11185325.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11185325.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11185325.countertg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanAddCounter(0x452,1) end
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,c,0x452,1)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,#g,0,0)
end
function c11185325.counterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,c,0x452,1)
	if c:IsRelateToEffect(e) then g:AddCard(c) end
	for tc in aux.Next(g) do
		if tc:IsCanAddCounter(0x452,1) then
			tc:AddCounter(0x452,1)
		end
	end
end