--贝利亚之子·捷德-惩罚真理
function c9950670.initial_effect(c)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950670,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,99506700)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c9950670.spcost)
	e1:SetTarget(c9950670.sptg)
	e1:SetOperation(c9950670.spop)
	c:RegisterEffect(e1)
 --position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950670,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,99506701)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c9950670.postg)
	e3:SetOperation(c9950670.posop)
	c:RegisterEffect(e3)
	 --draw
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(9950670,3))
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_REMOVE)
	e7:SetCountLimit(1,9950670)
	e7:SetTarget(c9950670.drtg)
	e7:SetOperation(c9950670.drop)
	c:RegisterEffect(e7)
   local e3=e7:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c9950670.drcon)
	c:RegisterEffect(e3)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950670.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950670.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950670,0))
end
function c9950670.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEUP)==5 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950670.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9950670.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9950670.posfilter(c)
	return not c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsCanChangePosition()
end
function c9950670.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950670.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c9950670.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c9950670.chlimit)
end
function c9950670.chlimit(e,ep,tp)
	return tp==ep
end
function c9950670.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9950670.posfilter,tp,0,LOCATION_MZONE,nil)
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
		local og=Duel.GetOperatedGroup()
		local tc=og:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=og:GetNext()
		end
	end
   Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950670,0))
end
function c9950670.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9950670.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9950670.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end