--方舟骑士-迷迭香
c29065546.named_with_Arknight=1
function c29065546.initial_effect(c)
	aux.AddCodeList(c,29065500,29065502)
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
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19065546)
	e2:SetCondition(c29065546.xspcon1)
	e2:SetCost(c29065546.xspcost)
	e2:SetTarget(c29065546.xsptg)
	e2:SetOperation(c29065546.xspop)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c29065546.xspcon2)
	c:RegisterEffect(e3)
end
c29065546.kinkuaoi_Akscsst=true
function c29065546.cfilter(c)
	return c:IsFaceup() and c:IsCode(29065500,29065502)
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
function c29065546.xspcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(29048740)==0
end
function c29065546.xspcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(29048740)>0
end
function c29065546.xspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c29065546.xsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29065547,0,TYPES_TOKEN_MONSTER,0,2000,6,RACE_MACHINE,ATTRIBUTE_EARTH) and  Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c29065546.dsfil(c,e,tp) 
	return c:GetColumnGroup():Filter(Card.IsControler,nil,tp):IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) 
end  
function c29065546.xspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,29065547,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,2000,6,RACE_MACHINE,ATTRIBUTE_EARTH) then
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
		Duel.BreakEffect()
		local dg=Duel.GetMatchingGroup(c29065546.dsfil,tp,0,LOCATION_MZONE,nil,e,tp) 
		Duel.HintSelection(dg) 
		Duel.Destroy(dg,REASON_EFFECT)
	end 
end




