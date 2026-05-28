--方舟骑士-迷迭香
function c29065546.initial_effect(c)
	aux.AddCodeList(c,29065500,29065502,29056009)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065546,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29065546)
	e1:SetCondition(c29065546.spcon)
	e1:SetTarget(c29065546.sptg)
	e1:SetOperation(c29065546.spop)
	c:RegisterEffect(e1)   
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065546,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,29065547)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c29065546.xspcon)
	e2:SetTarget(c29065546.xsptg)
	e2:SetOperation(c29065546.xspop)
	c:RegisterEffect(e2)  
end
c29065546.kinkuaoi_Akscsst=true
function c29065546.cfilter(c)
	return c:IsFaceup() and c:IsCode(29056009,29065500,29065502)
end
function c29065546.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29065546.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c29065546.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29065546.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c29065546.xspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c29065546.xsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c29065546.ggfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c29065546.dsfilter(c,tp)
	local g=c:GetColumnGroup()
	return g:IsExists(c29065546.ggfilter,1,nil,tp)
end
function c29065546.xspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,29065547,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,2500,6,RACE_MACHINE,ATTRIBUTE_EARTH) and Duel.SelectYesNo(tp,aux.Stringid(29065546,2)) then
				Duel.BreakEffect()
				local count=math.min(ft,2)
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then count=1 end
					if count>1 then
						local num={}
						local i=1
						while i<=count do
							num[i]=i
							i=i+1
						end
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29065546,1))
					count=Duel.AnnounceNumber(tp,table.unpack(num))
					end
				repeat
					local token=Duel.CreateToken(tp,29065547)
					Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
					count=count-1
				until count==0
				Duel.SpecialSummonComplete()
		end
		local g=Duel.GetMatchingGroup(c29065546.dsfilter,tp,0,LOCATION_MZONE,nil,tp)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(29065546,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g1=Duel.SelectMatchingCard(tp,c29065546.dsfilter,tp,0,LOCATION_MZONE,1,6,nil,tp)
				Duel.HintSelection(g1)
				Duel.Destroy(g1,REASON_EFFECT)
		end
	end
end