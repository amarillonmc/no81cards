--闇邪咏奏《王权之终奏》
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	s.dam(c)
	s.set(c)
end
function s.set(c)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.settg)
	e5:SetOperation(s.setop)
	c:RegisterEffect(e5)
end
function s.setfilter(c,tp,check)
	local b1=c:IsCode(71210110) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
	local b2=c:IsSetCard(0x897) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
	return b1 or (check and b2)
end
function s.checkfilter(c)
	return c:IsCode(71210110) and c:IsFaceup()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local check=Duel.IsExistingMatchingCard(s.checkfilter,tp,LOCATION_ONFIELD,0,1,nil)
		return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,tp,check) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	--Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	local check=Duel.IsExistingMatchingCard(s.checkfilter,tp,LOCATION_ONFIELD,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp,check)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand() and tc:IsSetCard(0x897) and tc:IsType(TYPE_MONSTER)
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
		local b2=tc:IsCode(71210110) and tc:IsType(TYPE_FIELD) and tc:GetActivateEffect():IsActivatable(tp,true,true)
		Duel.ResetFlagEffect(tp,15248873)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local te=tc:GetActivateEffect()
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end

function s.dam(c)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1122)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
end
local spcode=71210155
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,200)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN)
	s.exop(e,tp,eg,ep,ev,re,r,rp)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCode(spcode) and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	tc:CompleteProcedure()
end
function s.exop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct==1 and s.boostg(e,tp,eg,ep,ev,re,r,rp,0) then
		Duel.BreakEffect()
		s.boostp(e,tp,eg,ep,ev,re,r,rp)
	end 
	if ct==5 and s.target(e,tp,eg,ep,ev,re,r,rp,0) then
		Duel.BreakEffect()
		s.activate(e,tp,eg,ep,ev,re,r,rp)
	end 
end
function s.boostg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(2857636,1)) end
end
function s.boostp(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
