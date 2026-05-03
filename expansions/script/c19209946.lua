--饥献的甘醇好饵
function c19209946.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209946,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,19209946)
	e1:SetTarget(c19209946.sptg)
	e1:SetOperation(c19209946.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209946,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,19209946+1)
	e2:SetTarget(c19209946.thtg)
	e2:SetOperation(c19209946.thop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19209946,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,19209946+2)
	e3:SetCondition(c19209946.descon)
	e3:SetTarget(c19209946.destg)
	e3:SetOperation(c19209946.desop)
	c:RegisterEffect(e3)
end
function c19209946.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_GRAVE,nil,e,0,1-tp,false,false)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.GetMZoneCount(1-tp)>0 and #g>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,1-tp,LOCATION_GRAVE)
end
function c19209946.spop(e,tp,eg,ep,ev,re,r,rp)
	local p=1-tp
	local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_GRAVE,nil,e,0,p,false,false)
	if #g>0 and Duel.GetMZoneCount(p)>0 then
		local ft=Duel.IsPlayerAffectedByEffect(p,59822133) and 1 or Duel.GetMZoneCount(p)
		ft=math.min(3,ft)
		if #g>ft then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			g=g:Select(p,ft,ft,nil)
		end
		Duel.SpecialSummon(g,0,p,p,false,false,POS_FACEUP)
		local og=Duel.GetOperatedGroup()
			for tc in aux.Next(og) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		end
		local ct=math.floor(Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)/3)
		if Duel.IsPlayerCanDraw(tp) then Duel.BreakEffect() end
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function c19209946.lvfilter(c,lv)
	return c:IsLevel(lv) and c:IsFaceup()
end
function c19209946.thfilter(c,tp)
	return c:IsSetCard(0xb54) and c:IsLevelBelow(6) and c:IsAbleToHand() and not Duel.IsExistingMatchingCard(c19209946.lvfilter,tp,LOCATION_MZONE,0,1,nil,c:GetLevel())
end
function c19209946.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209946.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c19209946.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19209946.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	--if not tc:IsLocation(LOCATION_HAND) or not Duel.SelectYesNo(tp,aux.Stringid(19209946,2)) then return end
end
function c19209946.cfilter(c)
	return c:IsSetCard(0xb54) and c:IsType(TYPE_RITUAL) and c:IsFaceup()
end
function c19209946.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209946.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c19209946.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c19209946.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209946.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c19209946.desfilter,tp,0,LOCATION_ONFIELD,nil)
	sg:AddCard(e:GetHandler())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c19209946.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c19209946.desfilter,tp,0,LOCATION_ONFIELD,nil)
	sg:AddCard(e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
