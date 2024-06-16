--暗海的月主
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
function Dark_Sea_counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
Duel.AddCustomActivityCounter(11633000,ACTIVITY_SPSUMMON,Dark_Sea_counterfilter)
function Dark_Sea_Effect(c,id)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCost(Dark_Sea_spcost)
	e1:SetCondition(Dark_Sea_spcon)
	e1:SetTarget(Dark_Sea_sptg) 
	e1:SetOperation(Dark_Sea_spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCondition(Dark_Sea_pucon)
	e2:SetOperation(Dark_Sea_puop)
	c:RegisterEffect(e2)
end
function Dark_Sea_pucon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic()
end
function Dark_Sea_puop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function Dark_Sea_spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11633000,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(Dark_Sea_splimit)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function Dark_Sea_splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function Dark_Sea_spfilter(c,e,tp,mg)
	if bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or  not c:IsSetCard(0xa220) then return false end
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	if c.mat_filter then
		mg2=mg2:Filter(c.mat_filter,nil,tp)
	end
	return mg2:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function Dark_Sea_matfilter(c)
	return c:IsLevelAbove(1) and c:IsAbleToGrave() and c:IsSetCard(0xa220)
end
function Dark_Sea_spcon(e,tp,eg,ep,ev,re,r,rp)

	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and (e:GetHandler():IsReason(REASON_EFFECT) and (e:GetHandler():GetReasonPlayer()==1-tp or e:GetHandler():IsSetCard(0xa220)))
end
function Dark_Sea_sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Dark_Sea_matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		if Duel.GetFlagEffect(tp,11633001)<2 then 
			mg=Duel.GetMatchingGroup(Dark_Sea_matfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,nil)
		end
		if Duel.GetFlagEffect(tp,11633002)<1 then
			return Duel.IsExistingMatchingCard(Dark_Sea_spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
		else
			return Duel.IsExistingMatchingCard(Dark_Sea_spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function Dark_Sea_spop(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetMatchingGroup(Dark_Sea_matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if Duel.GetFlagEffect(tp,11633001)<2 then 
		mg=Duel.GetMatchingGroup(Dark_Sea_matfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Group.CreateGroup()
	if Duel.GetFlagEffect(tp,11633002)<1 then
		sg=Duel.SelectMatchingCard(tp,Dark_Sea_spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	else
		sg=Duel.SelectMatchingCard(tp,Dark_Sea_spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	end
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		mg:RemoveCard(tc)
		
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil,tp)
		end
		
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		aux.GCheckAdditional=function(sg) return sg:GetSum(Card.GetRitualLevel,tc)<=lv end
		local mat=mg:SelectSubGroup(tp,aux.RitualCheckEqual,true,1,99,tc,lv)
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)

		if mat:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.RegisterFlagEffect(tp,11633001,RESET_PHASE+PHASE_END,0,1) end
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		if tc:IsLocation(LOCATION_DECK) then Duel.RegisterFlagEffect(tp,11633002,RESET_PHASE+PHASE_END,0,1) end
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--
local s,id,o=GetID()
function s.initial_effect(c)
	Dark_Sea_Effect(c,id)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+1)
	e1:SetCondition(s.tdcon)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--must attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e3)
	--attack target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	c:RegisterEffect(e4)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local fg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local g
	if #hg>0 and (#fg==0 or Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))==0) then
		g=hg:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	end
	if g:GetCount()~=0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFF,LEREASON_RULE)
	end
	Duel.BreakEffect()
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
--
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if not bc then return false end
	e:SetLabelObject(bc)
	return bc:IsControler(1-tp) and bc:IsRelateToBattle()
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=e:GetLabelObject()
	if chk==0 then return bc and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsFaceup() and bc:IsRelateToBattle() and bc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(math.ceil(bc:GetAttack()/2))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		bc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(math.ceil(bc:GetDefense()/2))
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		bc:RegisterEffect(e2)
	end
end

