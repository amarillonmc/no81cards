--守墓的信者
function c98920710.initial_effect(c)
	aux.AddCodeList(c,47355498)
		--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920710,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920710)
	e1:SetTarget(c98920710.target)
	e1:SetOperation(c98920710.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
		--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920710,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,98930710)
	e4:SetCondition(c98920710.tgcon)
	e4:SetTarget(c98920710.tgtg)
	e4:SetOperation(c98920710.tgop)
	c:RegisterEffect(e4)
	--
	if not c98920710.global_check then
		c98920710.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(c98920710.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c98920710.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsCode(3381441) or tc:IsCode(17393207) or tc:IsCode(21663205) or tc:IsCode(22134079) or tc:IsCode(23927567) or tc:IsCode(24140059) or tc:IsCode(25262697) or tc:IsCode(30450531) or tc:IsCode(46955770) or tc:IsCode(56773577) or tc:IsCode(58139128) or tc:IsCode(58657303) or tc:IsCode(62473983) or tc:IsCode(70000776) or tc:IsCode(72405967) or tc:IsCode(79206925) or tc:IsCode(90434657) or tc:IsCode(99523325) or tc:IsCode(7481441) or tc:IsCode(98920383) or tc:IsCode(62101010) then
			aux.AddCodeList(tc,47355498)
		end
		tc=g:GetNext()
	end
end
function c98920710.filter(c)
	return ((aux.IsCodeListed(c,47355498) and not c:IsCode(98920710)) or c:IsCode(47355498)) and c:IsAbleToHand()
end
function c98920710.target(e,tp,eg,ep,ev,re,r,rp,chk,_,exc)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920710.filter,tp,LOCATION_DECK,0,1,exc) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920710.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920710.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920710.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(47355498)
end
function c98920710.tgfilter(c)
	return c:IsSetCard(0x2e) and c:IsLevelAbove(0) and c:IsAbleToGrave()
end
function c98920710.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920710.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98920710.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920710.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and c:IsFaceup() then
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lv*100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end