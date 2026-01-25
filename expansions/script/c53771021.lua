--剧毒蚀茧者
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function c53771021.initial_effect(c)
	SNNM.Sarcoveil_Sort(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetDescription(aux.Stringid(53771021,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c53771021.rmcon)
	e1:SetCost(c53771021.rmcost)
	e1:SetTarget(c53771021.rmtg)
	e1:SetOperation(c53771021.rmop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53771021,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e2:SetTarget(c53771021.thtg)
	e2:SetOperation(c53771021.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
end
function c53771021.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c53771021.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c53771021.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.GetFlagEffect(tp,53771021)<Duel.GetTurnCount() and #g>0 end
	Duel.RegisterFlagEffect(tp,53771021,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c53771021.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.Remove(tc,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetLabelObject(tc)
		e0:SetCountLimit(1)
		e0:SetOperation(c53771021.retop)
		e0:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(53771021,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(53771021)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e1)
		local ct=Duel.GetCurrentChain()
		if ct<=1 then return end
		local p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_PLAYER)
		if p==1-tp and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>0 and tc:IsType(TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(53771021,2)) then
			if tc:IsFaceup() then Duel.HintSelection(Group.FromCards(tc)) else Duel.ConfirmCards(1-tp,tc) end
			if not tc:IsSetCard(0xa53b) then return end
			local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			local fg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
			local g
			if #hg>0 and (#fg==0 or Duel.SelectOption(tp,aux.Stringid(53771021,3),aux.Stringid(53771021,4))==0) then
				g=hg:RandomSelect(tp,1)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
			end
			if g:GetCount()~=0 then
				Duel.HintSelection(g)
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
function c53771021.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject(),POS_FACEDOWN_DEFENSE)
end
function c53771021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,53771022)<Duel.GetTurnCount() end
	Duel.RegisterFlagEffect(tp,53771022,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c53771021.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Damage(1-tp,200,REASON_EFFECT)~=0 and c:IsRelateToChain() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
