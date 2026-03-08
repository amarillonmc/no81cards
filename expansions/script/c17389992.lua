--终烬启程 
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.thtg2)
	e2:SetOperation(s.thop2)
	c:RegisterEffect(e2)
end

function s.filter(c)
	return c:IsSetCard(0x5f51) and (c:IsAbleToHand() or c:IsDestructable())
end

function s.desfilter(c,type)
	return c:IsSetCard(0x5f51) and c:IsDestructable() 
		and not (c:GetType() & type > 0)
end

function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) 
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end

	local type=tc:GetType() & (TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	local b1=tc:IsAbleToHand()
	local b2=tc:IsDestructable()
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,1190,aux.Stringid(id,2)) elseif b1 then op=0 else op=1 end		

	local res=0
	if op==0 then
		res=Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		res=Duel.Destroy(tc,REASON_EFFECT)
	end		

	if res~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,type)
		if #dg>0 then
			local dc=dg:GetFirst()
			if dc:IsFacedown() or dc:IsLocation(LOCATION_HAND) then 
				Duel.ConfirmCards(1-tp,dc) 
			end
			Duel.HintSelection(dg)
			Duel.Destroy(dc,REASON_EFFECT)
		end
	end
end
function s.thfilter2(c,tp)
	return c:IsSetCard(0x5f51) and (c:IsAbleToHand() or c:IsDestructable())
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:IsDestructable()
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,1190,aux.Stringid(id,2)) elseif b1 then op=0 else op=1 end

		if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end