--正义之心罪·白雪公主
function c29010410.initial_effect(c)
	--th 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010410,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c29010410.thcon)
	e1:SetTarget(c29010410.thtg)
	e1:SetOperation(c29010410.thop)
	c:RegisterEffect(e1)	
	--sp 2 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,29010410)
	e2:SetCondition(c29010410.xspcon)
	e2:SetTarget(c29010410.xsptg)
	e2:SetOperation(c29010410.xspop)
	c:RegisterEffect(e2)	 
end
function c29010410.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c29010410.thfil(c) 
	return c:IsSetCard(0x7a1) and c:IsAbleToGrave() 
end 
function c29010410.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29010410.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_GRAVE)  
end 
function c29010410.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29010410.thfil,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()<=0 then return end 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
		if Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(29010410,2)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
end 
function c29010410.cfilter(c,tp,rp)
	return c:IsPreviousControler(tp) and bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)~=0
		and c:IsPreviousSetCard(0x7a1) and not c:IsPreviousSetCard(0x37a1) and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function c29010410.xspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29010410.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function c29010410.xsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29010410.xspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end





