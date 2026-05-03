-- 对命运的未来
local s,id,o=GetID()
function s.initial_effect(c)
	-- 发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 过滤「命运之扉」
function s.rmfilter(c)
	return c:IsCode(27062594) and c:IsAbleToRemove()
end

-- 过滤「未来皇 霍普」超量怪兽
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x207f) and c:IsType(TYPE_XYZ) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 1. 选1张「命运之扉」除外
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		
		-- 2. 特殊召唤「未来皇 霍普」
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=sg:GetFirst()
		if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
			tc:CompleteProcedure() -- 当作超量召唤
			
			-- 3. 把这张卡作为超量素材
			if c:IsRelateToEffect(e) then
				c:CancelToGrave() -- 防止魔法卡结算后送入墓地
				Duel.Overlay(tc,Group.FromCards(c))
			end
		end
	end
	
	-- 4. 那之后，这次主要阶段结束
	local ph=Duel.GetCurrentPhase()
	if ph==PHASE_MAIN1 then
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	elseif ph==PHASE_MAIN2 then
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end