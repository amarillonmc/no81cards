--通常陷阱1
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function c53771069.initial_effect(c)
	SNNM.Sarcoveil_Sort(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53771069+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c53771069.condition)
	e1:SetTarget(c53771069.target)
	e1:SetOperation(c53771069.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c53771069.tgcost)
	e2:SetTarget(c53771069.tgtg)
	e2:SetOperation(c53771069.tgop)
	c:RegisterEffect(e2)
end
function c53771069.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=4
end
function c53771069.cfilter(c,e,tp)
	return not c:IsPublic() or c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEDOWN_DEFENSE,1-tp)
end
function c53771069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(1-tp)>0
		and Duel.IsExistingMatchingCard(c53771069.cfilter,tp,0,LOCATION_HAND,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c53771069.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	if #g==0 or Duel.GetMZoneCount(1-tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,0,LOCATION_HAND,1,1,nil,e,0,tp,true,false,POS_FACEDOWN_DEFENSE,1-tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,1-tp,true,false,POS_FACEDOWN_DEFENSE)
		tc:RegisterFlagEffect(53771069,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53771069,4))
		tc:SetStatus(STATUS_CANNOT_CHANGE_FORM,false)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_FLIPSUMMON_COST)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetLabel(1)
		e1:SetLabelObject(tc)
		e1:SetTargetRange(0xff,0xff)
		e1:SetTarget(c53771069.fstg)
		e1:SetCost(SNNM.Sarcoveil_fscost)
		e1:SetOperation(SNNM.Sarcoveil_fsop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c53771069.fstg(e,c,tp)
	if c:GetFlagEffect(53771069)==0 or e:GetLabelObject()~=c then return false end
	Sarcoveil_Fsing=c
	return true
end
function c53771069.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c53771069.tgfilter(c)
	return c:IsSetCard(0xa53b) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c53771069.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53771069.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c53771069.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c53771069.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
