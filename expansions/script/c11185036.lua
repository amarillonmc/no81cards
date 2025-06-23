-- 龗龘怪兽
local s,id=GetID()

function s.initial_effect(c)
	-- 效果①：特召+解放+特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- 效果②：召唤/特召时限制种族
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(s.limitop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	-- 效果③：离场时进行特殊召唤
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,id+1)
	e4:SetTarget(s.sumtg)
	e4:SetOperation(s.sumop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_DESTROY)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e7)
end

function s.spfilter1(c)
	return c:IsFaceup() and not c:IsSetCard(0x5450)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g==0 or not Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_MZONE,0,1,nil)
end

-- 效果①目标：特召+解放+特召
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- 效果①操作：特召+解放+特召
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 选卡解放
		local g=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		if #g>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local dg=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			if #dg>0 and Duel.Release(dg,REASON_EFFECT)>0 then
				-- 特召卡组的龗龘怪兽(除龗龘䨻)
				local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
				if #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=sg:Select(tp,1,1,nil)
					if #tg>0 then
						Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
					end
				end
			end
		end
		-- 限制卡组召唤
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e2,tp)
	end
end

-- 效果①特召目标筛选(除龗龘䨻)
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5450)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 效果①限制：不能从卡组召唤/特召非龗龘怪兽
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_DECK) and not c:IsSetCard(0x5450)
end

-- 效果②操作：限制种族特召
function s.limitop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

-- 效果②限制：只能特召龙族/恐龙族/海龙族/幻龙族
function s.splimit2(e,c)
	return not (c:IsRace(RACE_DRAGON+RACE_DINOSAUR+RACE_SEASERPENT+RACE_WYRM))
end
-- 效果③目标：进行特殊召唤
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.xfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b4=s.fufilter(e,tp)
	if chk==0 then return b1 or b2 or b3 or b4 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xfilter(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x5450)
end
function s.sfilter(c)
	return c:IsSynchroSummonable(nil)and c:IsSetCard(0x5450)
end
function s.lfilter(c)
	return c:IsLinkSummonable(nil)and c:IsSetCard(0x5450)
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x5450)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.fufilter(e,tp)
local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
end
-- 效果③操作：进行特殊召唤
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.xfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b4=s.fufilter(e,tp)
			local off=1
			local ops={}
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(id,3)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(id,4)
				opval[off-1]=2
				off=off+1
			end
			if b3 then
				ops[off]=aux.Stringid(id,5)
				opval[off-1]=3
				off=off+1
			end
			 if b4 then
				ops[off]=aux.Stringid(id,6)
				opval[off-1]=4
				off=off+1
			end  
			local op=Duel.SelectOption(tp,table.unpack(ops)) 
			if opval[op]==1 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.SynchroSummon(tp,g:GetFirst(),nil)
			elseif opval[op]==2 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.xfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.XyzSummon(tp,g:GetFirst(),nil)
			elseif opval[op]==3 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.lfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.LinkSummon(tp,g:GetFirst(),nil)
			else 
				local chkf=tp
				local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e):Filter(Card.IsLocation,nil,LOCATION_MZONE)
				local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
				local mg2=nil
				local sg2=nil
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
				end
				if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
					local sg=sg1:Clone()
					if sg2 then sg:Merge(sg2) end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=sg:Select(tp,1,1,nil)
					local tc=tg:GetFirst()
					if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
						local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
						tc:SetMaterial(mat1)
						Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
						Duel.BreakEffect()
						Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
					else
						local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
						local fop=ce:GetOperation()
						fop(ce,e,tp,tc,mat2)
					end
					tc:CompleteProcedure()
				end
			end
end
