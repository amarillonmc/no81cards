--空想万象 森罗
function c33310211.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x551),aux.FilterBoolFunction(Card.IsFusionType,TYPE_TUNER),true)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,33310211)
	e1:SetCondition(c33310211.con)
	e1:SetTarget(c33310211.tg)
	e1:SetOperation(c33310211.op)
	c:RegisterEffect(e1)
	 --Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33310211,2))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c33310211.codisable)
	e3:SetTarget(c33310211.tgdisable)
	e3:SetOperation(c33310211.opdisable)
	c:RegisterEffect(e3)
end
function c33310211.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) 
end
function c33310211.thfilter(c)
	return c:IsSetCard(0x551) and c:IsSetCard(0x46) and (c:IsAbleToHand() or c:IsAbleToDeck())
end
function c33310211.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310211.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c33310211.thfilter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x551)
end
function c33310211.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c33310211.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local op=99
		local b1=tc:IsAbleToHand()
		local b2=tc:IsAbleToDeck()
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(33310211,0),aux.Stringid(33310211,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(33310211,0))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(33310211,1))+1
		end
		if op==0 then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
		elseif op==1 then
			if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsCode(33310200) and tc:IsLocation(LOCATION_DECK) and Duel.IsExistingMatchingCard(c33310211.thfilter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33310211,2)) then
				local thg=Duel.SelectMatchingCard(tp,c33310211.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
				Duel.SendtoHand(thg,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,thg)
			end
		end
	end
end
function c33310211.codisable(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x551) and re:IsActiveType(TYPE_MONSTER) and rp==tp and re:GetActivateLocation()==LOCATION_HAND 
end
function c33310211.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c33310211.opdisable(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local gc=g:GetFirst()
	Duel.ConfirmCards(1-tp,gc)
	if gc:IsSetCard(0x551) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33310211,3)) then
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(sg)
		local sgc=sg:GetFirst()
		if Duel.SendtoHand(sgc,nil,REASON_EFFECT)~=0 then
			local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	sgc:RegisterEffect(e2)
		end
	end
end