--天觉龙 拿欧
local s,id=GetID()
s.named_with_AwakenedDragon=1

s.MITRA_CODE=40020256

function s.AwakenedDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AwakenedDragon
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020256)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2a)
end

function s.check_mitra(tp)
	local ex=Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(s.MITRA_CODE) end,tp,LOCATION_EXTRA,0,1,nil)
	local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local pz=((pz0 and pz0:IsCode(s.MITRA_CODE)) or (pz1 and pz1:IsCode(s.MITRA_CODE)))
	return ex or pz
end

function s.cfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DRAW then return false end
	if not s.check_mitra(tp) then return false end
	return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
	Duel.ShuffleHand(tp)
end

function s.rmfilter(c)
	return s.AwakenedDragon(c) and not c:IsCode(id) and c:IsAbleToRemove()
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,c)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local op_hand = Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	local my_hand = Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return op_hand > my_hand and s.check_mitra(tp)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local op_hand = Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	local dr_ct = math.floor(op_hand / 2)
	if chk==0 then return dr_ct > 0 and Duel.IsPlayerCanDraw(tp,dr_ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dr_ct)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local op_hand = Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	local dr_ct = math.floor(op_hand / 2)
	if dr_ct > 0 and Duel.IsPlayerCanDraw(p, dr_ct) then
		local ct = Duel.Draw(p,dr_ct,REASON_EFFECT)
		if ct >= 2 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) then
			if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
				if #tg>0 then
					Duel.SendtoDeck(tg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
				end
			end
		end
	end
end