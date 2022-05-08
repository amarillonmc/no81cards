--灵兽训练师 柳伯
function c33200902.initial_effect(c)
	c:SetUniqueOnField(1,1,33200902)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c33200902.lcheck) 
	--e1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200902,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33220902)
	e1:SetTarget(c33200902.thtg)
	e1:SetOperation(c33200902.thop)
	c:RegisterEffect(e1) 
	--cannot be battle traget
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	--cant link
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e5)
end

function c33200902.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x332a)
end

--e1
function c33200902.ctfilter1(c,tp)
	return c:IsSetCard(0x332a) and c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c33200902.ctfilter2,tp,LOCATION_EXTRA,0,1,nil,tp,c:GetCode())
end 
function c33200902.ctfilter2(c,tp,code)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x332a) and c:IsAbleToHand() and not c:IsCode(code)
end

function c33200902.schfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x332a) and c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c33200902.schfilter2,tp,LOCATION_EXTRA,0,1,nil,tp,c:GetCode()) and c:IsAbleToDeck()
end
function c33200902.schfilter2(c,tp,code1)
	return c:IsFaceup() and c:IsSetCard(0x332a) and c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c33200902.schfilter3,tp,LOCATION_DECK,0,1,nil,tp,code1,c:GetCode()) and c:IsAbleToDeck() and not c:IsCode(code1)
end
function c33200902.schfilter3(c,tp,code1,code2)
	return c:IsAbleToHand() and c:IsSetCard(0x332a) and not (c:IsCode(code1) or c:IsCode(code2))
end
function c33200902.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c33200902.ctfilter1,tp,LOCATION_DECK,0,1,nil,tp) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c33200902.schfilter1,tp,LOCATION_EXTRA,0,1,nil,tp) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33200902,2))
		sel=Duel.SelectOption(tp,aux.Stringid(33200902,0),aux.Stringid(33200902,1))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(33200902,0))
	else
		Duel.SelectOption(tp,aux.Stringid(33200902,1))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_EXTRA)
	end
end
function c33200902.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		if Duel.IsExistingMatchingCard(c33200902.ctfilter1,tp,LOCATION_DECK,0,1,nil,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33200902,3))
			local g1=Duel.SelectMatchingCard(tp,c33200902.ctfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
			local tc1=g1:GetFirst()
			local code=tc1:GetCode()
			Duel.SendtoExtraP(g1,tp,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,c33200902.ctfilter2,tp,LOCATION_EXTRA,0,1,1,nil,tp,code)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	else
		if Duel.IsExistingMatchingCard(c33200902.schfilter1,tp,LOCATION_EXTRA,0,1,nil,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g1=Duel.SelectMatchingCard(tp,c33200902.schfilter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
			local tc1=g1:GetFirst()
			local code1=tc1:GetCode()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g2=Duel.SelectMatchingCard(tp,c33200902.schfilter2,tp,LOCATION_EXTRA,0,1,1,nil,tp,code1)
			local tc2=g2:GetFirst()
			local code2=tc2:GetCode()
			g1:Merge(g2)
			Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g3=Duel.SelectMatchingCard(tp,c33200902.schfilter3,tp,LOCATION_DECK,0,1,1,nil,tp,code1,code2)
			if g3:GetCount()>0 and g1:GetCount()>0 then
				Duel.SendtoHand(g3,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g3)
			end
		end
	end
end