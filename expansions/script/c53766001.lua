if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e1:SetTarget(s.extg)
	e1:SetOperation(s.exop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.con)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	s.self_destroy_effect=e2
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then tc:RegisterFlagEffect(id,RESET_EVENT+0x1f20000,0,1) elseif tc:IsLocation(LOCATION_EXTRA) then tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1) end end
end
function s.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(id)~=0 and c:IsFaceupEx() and c:IsAbleToDeck()
end
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(s.tdfilter,tp,0x70,0,1,nil) and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+SNNM.GetCurrentPhase(),0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x70)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.exop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if tc:IsSetCard(0x5534) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,0x70,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function s.rmfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemove(POS_FACEDOWN)
end
function s.thfilter(c,tp)
	return c:IsSetCard(0x5534) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,c:GetCode())
end
function s.spfilter(c,e,tp)
	return c:IsAttack(0) and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local c=e:GetHandler()
	if b1 or b2 then
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,2)},{b2,aux.Stringid(id,3)})
		if op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
			if Duel.SendtoHand(sc,nil,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_HAND) then
				Duel.ConfirmCards(1-tp,sc)
				local rc=SNNM.Select_1(Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_HAND+LOCATION_DECK,0,sc,sc:GetCode()),tp,HINTMSG_REMOVE)
				if rc and Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_REMOVED) then
					Duel.ConfirmCards(1-tp,rc)
					rc:RegisterFlagEffect(id+66,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
					local e2=Effect.CreateEffect(c)
					e2:SetDescription(aux.Stringid(id,5))
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_PHASE+PHASE_END)
					e2:SetReset(RESET_PHASE+PHASE_END)
					e2:SetLabelObject(rc)
					e2:SetCountLimit(1)
					e2:SetCondition(s.retcon)
					if rc:IsPreviousLocation(LOCATION_HAND) then e2:SetOperation(s.retop1) else e2:SetOperation(s.retop2) end
					Duel.RegisterEffect(e2,tp)
				end
			end
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(id,4))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetCountLimit(99)
				e1:SetValue(s.val)
				e1:SetReset(RESET_EVENT+0x7e0000)
				tc:RegisterEffect(e1)
			end
		end
	end
	local res=Duel.TossCoin(tp,1)
	if res==0 or not c:IsRelateToEffect(e) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetCountLimit(1)
	e2:SetOperation(s.desop)
	Duel.RegisterEffect(e2,tp)
	c:CreateEffectRelation(e2)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	if not c:IsRelateToEffect(e) then return end
	Duel.Destroy(c,REASON_EFFECT)
	e:Reset()
end
function s.val(e,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id+33)==0 then
		c:RegisterFlagEffect(id+33,RESET_EVENT+0x7e0000+RESET_PHASE+SNNM.GetCurrentPhase(),0,1)
		return true
	else return false end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id+66)~=0
end
function s.retop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
function s.retop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,2,REASON_EFFECT)
end
