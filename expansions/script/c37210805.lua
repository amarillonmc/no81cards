local s,id=GetID()
function s.initial_effect(c)
	-- 同调召唤手续：调整 + 调整以外的怪兽1只以上（使用 aux. 库）
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	-- 这个卡名的①②效果1回合各能使用1次。

	-- ①：这张卡特殊召唤的场合才能发动。自己墓地·除外状态的1只水属性·水族·守备力1300的怪兽加入手卡。那之后，可以把自己的1张手卡持续公开。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	-- ②：自己·对方的回合才能发动。自己场上的1只怪兽解放。自己除外的1只水属性·水族·守备力1300的怪兽特殊召唤。这个效果把同调怪兽解放的场合可以再把那只怪兽守备表示特殊召唤。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
end

-- ==================== 效果① ====================
function s.thfilter(c)
	-- 目标：墓地或除外状态（除外状态需表侧表示）的水属性·水族·守备力1300怪兽
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) 
		and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) 
		and c:GetDefense()==1300 and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.pubcfilter(c)
	return not c:IsPublic()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		-- 那之后，可以把自己的1张手卡持续公开
		local hg=Duel.GetMatchingGroup(s.pubcfilter,tp,LOCATION_HAND,0,nil)
		if #hg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local sg=hg:Select(tp,1,1,nil)
			Duel.ConfirmCards(1-tp,sg)
			local tc=sg:GetFirst()
			if tc then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end

-- ==================== 效果② ====================
function s.relcfilter(c,e,tp)
	-- 检查解放该怪兽后，场上是否有空位用于特殊召唤
	return c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c)>0
end
function s.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) 
		and c:GetDefense()==1300 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.relcfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,s.relcfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local rc=rg:GetFirst()
	if rc then
		-- 记录被解放怪兽的原始种类（同调怪兽）
		local isSynchro=rc:IsType(TYPE_SYNCHRO)
		
		-- 效果第一步：自己场上的1只怪兽解放
		if Duel.Release(rc,REASON_EFFECT)>0 then
			
			-- 效果第二步（句号间隔）：自己除外的1只水属性·水族·守备力1300的怪兽特殊召唤
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
			local sc=sg:GetFirst()
			if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
				
				-- 这个效果把同调怪兽解放的场合，可以再把那只怪兽守备表示特殊召唤
				-- 检查被解放的同调怪兽是否还在墓地/除外区且能被特召
				if isSynchro and rc:IsLocation(LOCATION_GRAVE|LOCATION_REMOVED) 
					and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then
					if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
						Duel.BreakEffect()
						Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
					end
				end
			end
		end
	end
end