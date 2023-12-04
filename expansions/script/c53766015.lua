if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.Excavated_Check(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(function(e)return e:GetHandler():GetFlagEffect(53766099)>0 end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.thfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsAbleToHand() and c:IsFaceup()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local sg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	if ct==0 then return end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetDescription(aux.Stringid(id,3))
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE_START+PHASE_END)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetLabel(ct)
	e0:SetLabelObject(Effect.GlobalEffect())
	e0:SetOperation(s.regop)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local e1=e0:Clone()
	e1:SetLabelObject(e0)
	e1:SetCode(EVENT_PHASE_START+PHASE_MAIN2)
	Duel.RegisterEffect(e1,tp)
	local e2=e0:Clone()
	e2:SetLabelObject(e1)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	Duel.RegisterEffect(e2,tp)
	local e3=e0:Clone()
	e3:SetLabelObject(e2)
	e3:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
	Duel.RegisterEffect(e3,tp)
	local e4=e0:Clone()
	e4:SetLabelObject(e3)
	e4:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	Duel.RegisterEffect(e4,tp)
	local e5=e0:Clone()
	e5:SetLabelObject(e4)
	e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	Duel.RegisterEffect(e5,tp)
end
function s.sfilter(c,e,tp)
	return c:IsSetCard(0x5534) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE) or c:IsSSetable())
end
function s.fselect(g,e,tp,ft1,ft2)
	local g1=g:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
	local g2=g:Filter(Card.IsSSetable,nil)
	local g3=Group.__band(g1,g2)
	return #g1-#g3<=ft1 and #g2-#g3<=ft2 and #g1+#g2-#g3<=ft1+ft2
end
function s.f(g,sg,e,tp,ft1,ft2)
	if g:IsExists(aux.NOT(Card.IsSSetable),1,nil) or ft2<#g then return false end
	local spg=Group.__sub(sg,g)
	if spg:IsExists(aux.NOT(Card.IsCanBeSpecialSummoned),1,nil,e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE) or ft1<#spg then return false end
	return true
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local le=e
	while le:GetLabelObject() do
		local te=le
		le=te:GetLabelObject()
		te:Reset()
	end
	local g=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local ct=e:GetLabel()
	if g:CheckSubGroup(s.fselect,1,math.min(ct,#g,ft1+ft2),e,tp,ft1,ft2) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:SelectSubGroup(tp,s.fselect,false,1,math.min(ct,#g,ft1+ft2),e,tp,ft1,ft2)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local stg=sg:SelectSubGroup(tp,s.f,false,1,math.min(#sg,ft2),sg,e,tp,ft1,ft2)
		if not stg then stg=Group.CreateGroup() end
		sg:Sub(stg)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
			local cg=sg:Filter(Card.IsFacedown,nil)
			if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
		end
		if #stg>0 then Duel.SSet(tp,stg) end
	end
end
function s.spfilter(c,e,tp)
	return c:IsAttack(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then Duel.Draw(tp,1,REASON_EFFECT) end
	end
end
