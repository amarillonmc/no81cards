--晨间音乐
local s,id,o=GetID()
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x351) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=sg:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tep=tc:GetControler()
		local PCe=tama.getTargetTable(tc,"power_capsule")
		if PCe and cm.canActivate(tc,PCe,eg,ep,ev,re,r,rp) then
			if not (cm.canActivate(tc,PCe,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(id,0))) then return end
			Duel.BreakEffect()
			local target=PCe:GetTarget()
			local operation=PCe:GetOperation()
			Duel.ClearTargetCard()
			e:SetProperty(PCe:GetProperty())
			tc:CreateEffectRelation(PCe)
			if target then target(PCe,tep,eg,ep,ev,re,r,rp,1) end
			if operation then operation(PCe,tep,eg,ep,ev,re,r,rp) end
			tc:ReleaseEffectRelation(PCe)
		else
			if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.tdfilter(c,id)
	return (c:IsSetCard(0x351) or c:IsSetCard(0x352)) and c:GetTurnID()==id and c:IsAbleToDeck()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(c)
	e1:SetOperation(s.tdop)
	Duel.RegisterEffect(e1,tp)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil,Duel.GetTurnCount())
	local ct=Duel.SendtoDeck(g,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	
	local tc=e:GetLabelObject()
	
	if ct:GetCount()>=3 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:GetFlagEffect(id) and tc:IsSSetable() then
		Duel.SSet(tp,dg)
	end
end
