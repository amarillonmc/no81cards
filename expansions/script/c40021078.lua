--菌树呜呜狼
local s,id=GetID()
s.named_with_FungalTree=1

s.TOKEN_MUSHROOM_BED=40020825

function s.FungalTree(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FungalTree
end

function s.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.lkfilter,2,2)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

function s.lkfilter(c,lc,sumtype,tp)
	return s.FungalTree(c)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function s.thfilter(c)
	return s.FungalTree(c) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function s.bedfilter(c)
	return c:IsFaceup() and c:IsCode(s.TOKEN_MUSHROOM_BED) and c:IsLocation(LOCATION_SZONE)
end

function s.spfilter(c,e,tp)
	return s.FungalTree(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.spcheck(g)
	return g:GetClassCount(Card.GetCode)==#g
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local bed_g = Duel.GetMatchingGroup(s.bedfilter,tp,LOCATION_SZONE,0,nil)
		local sp_g = Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		local sp_kinds = sp_g:GetClassCount(Card.GetCode)
		local ft = Duel.GetLocationCount(tp,LOCATION_MZONE)
		return #bed_g>0 and sp_kinds>0 and ft>0 
	end
	local bed_g = Duel.GetMatchingGroup(s.bedfilter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bed_g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local bed_g = Duel.GetMatchingGroup(s.bedfilter,tp,LOCATION_SZONE,0,nil)
	local sp_g = Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local ft = Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local sp_kinds = sp_g:GetClassCount(Card.GetCode)
	local max_ct = math.min(#bed_g, sp_kinds, ft)
	if max_ct <= 0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local des_g = bed_g:Select(tp, 1, max_ct, nil)
	if #des_g>0 then
		Duel.HintSelection(des_g)
		local des_ct = Duel.Destroy(des_g, REASON_EFFECT)
		if des_ct > 0 then
			local sp_g2 = Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg = sp_g2:SelectSubGroup(tp, s.spcheck, false, des_ct, des_ct)
			if sg and #sg == des_ct then
				for tc in aux.Next(sg) do
					if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
						if des_ct >= 3 and tc:IsType(TYPE_DUAL) then
							tc:EnableDualState()
						end
					end
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end
