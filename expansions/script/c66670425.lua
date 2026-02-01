--苍途终白的葬歌
local s,id,o=GetID()
function s.initial_effect(c)

    -- 自己·对方的主要阶段才能发动，自己的手卡·卡组·墓地1只「苍途」仪式怪兽给双方确认，那个等级每4星为1张的自己的墓地·除外状态的通常陷阱卡回到卡组，那之后，可以把给人观看的怪兽当作仪式召唤作特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	-- 自己的额外卡组没有卡存在的场合，这张卡在盖放的回合也能发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.actcon)
	c:RegisterEffect(e2)	
end

-- 自己·对方的主要阶段才能发动，自己的手卡·卡组·墓地1只「苍途」仪式怪兽给双方确认，那个等级每4星为1张的自己的墓地·除外状态的通常陷阱卡回到卡组，那之后，可以把给人观看的怪兽当作仪式召唤作特殊召唤
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end

function s.filter(c,e,tp,mg)
	if c:GetLevel()<4 then return false end
	local ct=math.floor(c:GetLevel()/4)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x666d)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
        and mg:CheckSubGroup(s.gcheck,ct,ct,tp,c)
end

function s.gcheck(g,tp,fc)
	return g:FilterCount(Card.IsAbleToDeck,nil)==g:GetCount()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(
	function(c)
		return c:GetType()==TYPE_TRAP and c:IsFaceupEx()
	end,
	tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil
)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	local mg=Duel.GetMatchingGroup(
		aux.NecroValleyFilter(function(c)
			return c:GetType()==TYPE_TRAP and c:IsFaceupEx()
		end),
		tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil
	)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	local tc=g:GetFirst()
	if not tc then return end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK)
	local og=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #hg>0 then Duel.ConfirmCards(1-tp,hg) end
	if #og>0 then Duel.HintSelection(og) end
	if g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>=1 then
		Duel.ShuffleHand(tp)
	end
	local ct=math.floor(tc:GetLevel()/4)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=mg:SelectSubGroup(tp,s.gcheck,false,ct,ct,tp,tc)
	if sg:GetCount()==0 then return end
	Duel.HintSelection(sg)
	if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0
		or sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	tc:SetMaterial(nil)
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) then
			tc:CompleteProcedure()
		end
	end
end

-- 自己的额外卡组没有卡存在的场合，这张卡在盖放的回合也能发动
function s.actcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0
end
