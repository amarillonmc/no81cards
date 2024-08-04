--人理之灵 卫宫士郎
function c22020210.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(22020210,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,22020210)
	e1:SetTarget(c22020210.tgtg)
	e1:SetOperation(c22020210.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--lv change
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(22020210,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22020211)
	e3:SetTarget(c22020210.lvtg)
	e3:SetOperation(c22020210.lvop)
	c:RegisterEffect(e3)
	--lv change
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(22020210,3))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,22020211)
	e4:SetCondition(c22020210.erescon)
	e4:SetTarget(c22020210.lvtg)
	e4:SetOperation(c22020210.lvop)
	c:RegisterEffect(e4)
end
c22020210.effect_canequip_hogu=true
c22020210.effect_with_master=true
function c22020210.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xff1) and c:IsAbleToGrave()
end
function c22020210.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020210.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c22020210.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c22020210.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then 
		Duel.BreakEffect()
		if tc:IsCode(22020020) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then 
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
			if c:IsRelateToEffect(e) then 
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_ADD_TYPE) 
				e1:SetRange(LOCATION_MZONE) 
				e1:SetValue(TYPE_TUNER) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
				c:RegisterEffect(e1) 
			end 
		end 
		if tc:IsCode(22020300) and Duel.IsExistingMatchingCard(function(c) return c:IsCode(22020230) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,1,nil) then 
			local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(22020230) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,1,1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
			if c:IsRelateToEffect(e) then 
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_CHANGE_CODE) 
				e1:SetRange(LOCATION_MZONE) 
				e1:SetValue(22020220) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
				c:RegisterEffect(e1) 
			end 
		end 
		if tc:IsCode(22020310) and Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xff1) and c:IsAbleToGrave() end,tp,LOCATION_DECK,0,1,nil) then 
			local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0xff1) and c:IsAbleToGrave() end,tp,LOCATION_DECK,0,1,1,nil) 
			Duel.SendtoGrave(sg,REASON_EFFECT)  
		end 
		if tc:IsCode(22020530) then 
			Duel.Hint(HINT_CARD,0,22020530)
			Duel.SelectOption(tp,aux.Stringid(22020210,4))
		end 
	end
end
function c22020210.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22020210,1))
	e:SetLabel(Duel.AnnounceLevel(tp,1,10,lv))
end
function c22020210.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c22020210.erescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end