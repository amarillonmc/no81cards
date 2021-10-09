--妖妖梦·莉莉霍瓦特
function c9951126.initial_effect(c)
	  --pendulum summon
	aux.EnablePendulumAttribute(c)
 --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951126,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9951126.pctg)
	e2:SetOperation(c9951126.pcop)
	c:RegisterEffect(e2)
 --send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951126,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,99511260)
	e3:SetTarget(c9951126.tgtg)
	e3:SetOperation(c9951126.tgop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
   --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951126.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951126.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951126,0))
end
function c9951126.pcfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x3bd2) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c9951126.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9951126.pcfilter(chkc) end
	local b1=Duel.IsExistingTarget(c9951126.pcfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c9951126.pcfilter,tp,LOCATION_EXTRA,0,1,nil)
	if chk==0 then
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
		return b1 or b2
	end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(9951126,1),aux.Stringid(9951126,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(9951126,1))
	else op=Duel.SelectOption(tp,aux.Stringid(9951126,2))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectTarget(tp,c9951126.pcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	else
		e:SetProperty(0)
	end
end
function c9951126.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c9951126.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951126,0))
end
function c9951126.tgfilter(c)
	return c:IsSetCard(0x3bd2) and not c:IsCode(9951126) and c:IsAbleToGrave()
end
function c9951126.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951126.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9951126.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9951126.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end