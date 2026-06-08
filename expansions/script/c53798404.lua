local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id+4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return not c:IsCode(id+4)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return sumtype&SUMMON_TYPE_RITUAL==SUMMON_TYPE_RITUAL
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=s.ritual_chk(e,tp)
	local b2=true
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,0),1},
		{b2,aux.Stringid(id,1),2})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		s.ritual_op(e,tp)
	elseif op==2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetCondition(s.applycon)
		e1:SetOperation(s.applyop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		e1:SetLabel(Duel.GetTurnCount())
		Duel.RegisterEffect(e1,tp)
	end
end
function s.applycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local b1=s.ritual_chk(e,tp)
	local b2=true
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,0),1},
		{b2,aux.Stringid(id,1),2})
	if op==1 then
		s.ritual_op(e,tp)
	elseif op==2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetCondition(s.applycon)
		e1:SetOperation(s.applyop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		e1:SetLabel(Duel.GetTurnCount())
		Duel.RegisterEffect(e1,tp)
	end
end

-- 仪式辅助逻辑
function s.rfilter(c)
	return c:IsCode(id+4) and c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function s.rfilter_self(c,e,tp)
	local dest=c:GetDestination()
	return c:IsCode(id+4) and c:IsOnField() and (dest==0 or dest==LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,c,TYPE_PENDULUM)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+4,0,c:GetType(),c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute()) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0
end
function s.ritual_chk(e,tp)
	local mg=Duel.GetRitualMaterial(tp)
	local ex_valid=Duel.IsExistingMatchingCard(s.RitualUltimateFilter,tp,LOCATION_EXTRA,0,1,nil,s.rfilter,e,tp,mg,nil,Card.GetLevel,"Greater")
	if ex_valid then return true end
	
	-- 检查能否解放自身仪式召唤
	for tc in aux.Next(mg) do
		if s.rfilter_self(tc,e,tp) then
			local mg_temp=mg:Clone()
			mg_temp:RemoveCard(tc)
			-- 如果它自己当祭品够的话，或者和别的组合
			local g=Group.FromCards(tc)
			if g:CheckWithSumGreater(Card.GetRitualLevel,4,tc) or mg_temp:CheckWithSumGreater(Card.GetRitualLevel,4-tc:GetRitualLevel(tc),tc) then
				return true
			end
		end
	end
	return false
end

function s.ritual_op(e,tp)
	local mg=Duel.GetRitualMaterial(tp)
	local tg1=Duel.GetMatchingGroup(s.RitualUltimateFilter,tp,LOCATION_EXTRA,0,nil,s.rfilter,e,tp,mg,nil,Card.GetLevel,"Greater")
	
	local tg2=Group.CreateGroup()
	for tc in aux.Next(mg) do
		if s.rfilter_self(tc,e,tp) then
			tg2:AddCard(tc)
		end
	end
	
	local tg=tg1:Clone()
	tg:Merge(tg2)
	if #tg==0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	
	if tc:IsLocation(LOCATION_EXTRA) then
		-- 普通仪式
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=s.RitualCheckAdditional(tc,4,"Greater")
		local mat=mg:SelectSubGroup(tp,s.RitualCheck,true,1,99,tp,tc,4,"Greater")
		aux.GCheckAdditional=nil
		if not mat then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	else
		-- 自身解放仪式
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		-- 必须包含tc自己，因为它是被选作目标并解放的
		mg:AddCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=s.RitualCheckAdditional(tc,4,"Greater")
		local mat=mg:SelectSubGroup(tp,s.RitualCheck,true,1,99,tp,tc,4,"Greater")
		aux.GCheckAdditional=nil
		if not mat then return end
		
		-- 必须要将自身包含在内
		if not mat:IsContains(tc) then
			mat:AddCard(tc)
		end
		
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		if tc:IsLocation(LOCATION_EXTRA) then
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end

-- =================以下为仪式召唤辅助内容保留=================
function s.RitualCheckGreater(g,c,lv)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetRitualLevel,lv,c)
end
function s.RitualCheck(g,tp,c,lv,greater_or_equal)
	if c:IsLocation(LOCATION_EXTRA) then
		if Duel.GetLocationCountFromEx(tp,tp,g,c)<=0 then return false end
	else
		if Duel.GetMZoneCount(tp,g,tp)<=0 then return false end
	end
	return s.RitualCheckGreater(g,c,lv) and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not aux.RCheckAdditional or aux.RCheckAdditional(tp,g,c))
end
function s.RitualCheckAdditionalLevel(c,rc)
	local raw_level=c:GetRitualLevel(rc)
	local lv1=raw_level&0xffff
	local lv2=raw_level>>16
	if lv2>0 then
		return math.min(lv1,lv2)
	else
		return lv1
	end
end
function s.RitualCheckAdditional(c,lv,greater_or_equal)
	return function(g,ec)
		if ec then
			return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g,ec)) and g:GetSum(s.RitualCheckAdditionalLevel,c)-s.RitualCheckAdditionalLevel(ec,c)<=lv
		else
			return not aux.RGCheckAdditional or aux.RGCheckAdditional(g)
		end
	end
end
function s.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=4
	aux.GCheckAdditional=s.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(s.RitualCheck,1,99,tp,c,lv,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
