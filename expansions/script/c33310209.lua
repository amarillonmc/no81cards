--空想幻墨 苍炎
function c33310209.initial_effect(c)
	 --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c33310209.lcheck)
	--ignition
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,33310209)
	e1:SetTarget(c33310209.tg)
	e1:SetOperation(c33310209.op)
	c:RegisterEffect(e1)
	 --to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33310209,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33310209.thcon)
	e3:SetTarget(c33310209.thtg)
	e3:SetOperation(c33310209.thop)
	c:RegisterEffect(e3)
end
function c33310209.cfilter(c,lg)
	return c:IsType(TYPE_FUSION) and lg:IsContains(c)
end
function c33310209.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c33310209.cfilter,1,nil,lg)
end
function c33310209.thfilter(c)
	return not c:IsPublic()
end
function c33310209.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310209.thfilter,tp,0,LOCATION_HAND,1,nil) end
end
function c33310209.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33310209.thfilter,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local sg=g:FilterSelect(tp,aux.TRUE,1,1,nil)
		Duel.HintSelection(sg)
		Duel.ShuffleHand(1-tp)
		local sc=sg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	sc:RegisterEffect(e1)
	end
end

function c33310209.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x551)
end
function c33310209.filter(c,e,tp)
	return c:IsSetCard(0x551) and c:IsType(TYPE_MONSTER) and
		(Duel.IsExistingMatchingCard(c33310209.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
		or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c33310209.tgfilter(c,code)
	return c:IsSetCard(0x551) and not c:IsCode(code) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c33310209.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33310209.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33310209.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33310209.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
end
function c33310209.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local op=99
		local b1=Duel.IsExistingMatchingCard(c33310209.tgfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode())
		local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(33310209,0),aux.Stringid(33310209,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(33310209,0))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(33310209,1))+1
		end
		if op==0 then
			local g=Duel.SelectMatchingCard(tp,c33310209.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
			if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(33310209,2)) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			end
		elseif op==1 then
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
			end
			Duel.SpecialSummonComplete()
		end
	end
end