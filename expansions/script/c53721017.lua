if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.SorisonFish(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(SNNM.SorisonTGCondition)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	s.sorison_cost_effect=e2
end
function s.fil(c,tp)
	if not (c:IsSetCard(0xa531) and c:IsRace(RACE_FISH) and c:IsAbleToDeck() and not c:IsCode(id)) then return false end
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil,tp) or c.sorison_cost_effect
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.fil(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.fil,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,s.fil,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	local opt=aux.SelectFromOptions(tp,{Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil,tp),aux.Stringid(id,1)},{tc.sorison_cost_effect,aux.Stringid(id,2)})
	if opt==1 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil),1,0,0)
		e:SetLabelObject(tc)
	elseif opt==2 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
		Duel.ClearTargetCard()
		tc:CreateEffectRelation(e)
		e:SetLabelObject(tc)
		local te=tc.sorison_cost_effect
		local tg=te:GetTarget()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		e:SetCategory(CATEGORY_TODECK)
	end
	e:SetOperation(s.tdop(opt))
end
function s.tdop(opt)
	return  function(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:IsRelateToEffect(e) then return end
	if opt==1 and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil,tp) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil,tp)
		local rg=g:RandomSelect(tp,1)
		local rc=rg:GetFirst()
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(rc)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
	if opt==2 and Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) and tc.sorison_cost_effect then
		local te=tc.sorison_cost_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)==0 then
		e:Reset()
		return false
	else return Duel.GetTurnPlayer()~=tp end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
end
