--猩红剧团「剧场组装体」
function c29010209.initial_effect(c)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29010209,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c29010209.tg)
	e4:SetOperation(c29010209.op)
	c:RegisterEffect(e4)
	if not c29010209.global_check then
		c29010209.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c29010209.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c29010209.filter(c)
	return c:IsSetCard(0x17af) and c:IsType(TYPE_MONSTER)
end
function c29010209.thfilter1(c,e,tp)
	return (c:IsSetCard(0x17af) and c:IsType(TYPE_MONSTER) and not c:IsCode(29010209) and c:IsLevelBelow(7))
end
function c29010209.thfilter2(c)
	return c:IsCode(29010200)
end
function c29010209.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c29010209.filter,tp,LOCATION_GRAVE,0,nil)
	local con1,con3,con5=nil
	if ct>=1 then
		con1=Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
	end
	if ct>=3 then
		con3=Duel.IsExistingMatchingCard(c29010209.thfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	if ct>=5 then
		con5=Duel.IsExistingMatchingCard(c29010209.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	if chk==0 then return con1 or con3 or con5 end
	local cat=0
	if ct>=1 then cat=cat+CATEGORY_DESTROY end
	if ct>=3 then cat=cat+CATEGORY_SPECIAL_SUMMON end
	if ct>=5 then cat=cat+CATEGORY_SEARCH+CATEGORY_TOHAND end
	e:SetCategory(cat)
end
function c29010209.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c29010209.filter,tp,LOCATION_GRAVE,0,nil)
	if ct>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
	if ct>=3 then
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c29010209.thfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if ct>=5 then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g3=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29010209.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g3:GetCount()<=0 then return end
		if g3:GetCount()>0 then
		Duel.SendtoHand(g3,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g3)
		end
		Duel.ResetFlagEffect(tp,29010209)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCondition(c29010209.discon)
		e1:SetValue(c29010209.actlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c29010209.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c29010209.discon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,29010209)==0
end
function c29010209.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsCode,1,nil,29010200) then
		Duel.RegisterFlagEffect(rp,29010209,RESET_PHASE+PHASE_END,0,1)
	end
end