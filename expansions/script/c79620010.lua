--不可名状之物
local s,id=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()


	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
	end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then
		return
	end

	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g<3 then return end

	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local opp_sel=g:Select(1-tp,1,1,nil)
	local opp_card=opp_sel:GetFirst()
	if not opp_card then return end

	g:RemoveCard(opp_card)
	Duel.SendtoHand(opp_card,1-tp,REASON_EFFECT)
	Duel.ConfirmCards(tp,opp_card)

	if #g==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local my_sel=g:Select(tp,1,1,nil)
		local my_card=my_sel:GetFirst()
		if not my_card then return end

		g:RemoveCard(my_card)

		local op=0
		if my_card:IsAbleToHand() and my_card:IsAbleToGrave() then
			op=Duel.SelectOption(tp,
				aux.Stringid(id,2),  
				aux.Stringid(id,3)   
			)
		elseif my_card:IsAbleToHand() then
			op=0
		else
			op=1
		end

		if op==0 then
			Duel.SendtoHand(my_card,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,my_card)
		else
			Duel.SendtoGrave(my_card,REASON_EFFECT)
		end
	end

	if #g==1 then
		local last_card=g:GetFirst()
		Duel.SendtoDeck(last_card,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end


function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	return c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:GetReasonPlayer()==1-tp
end


function s.disfilter(c)
	return c:IsFaceup()
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IsExistingTarget(s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end


function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	if not tc:IsRelateToEffect(e) then return end
	if not tc:IsFaceup() then return end
	
  
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
	tc:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
	

	if tc:IsType(TYPE_TRAPMONSTER) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
end