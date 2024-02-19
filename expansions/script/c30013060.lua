--深土的追迹者
local m=30013060
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	--Effect 2  
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_TOHAND)
	e12:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_DISCARD)
	e12:SetCountLimit(1,m+100)
	e12:SetTarget(cm.tg2)
	e12:SetOperation(cm.op2)
	c:RegisterEffect(e12)
end
--Effect 1
function cm.pf(c,tp)
	return not c:IsForbidden() and c:CheckUniqueOnField(tp) 
		and c:IsSetCard(0x92c) and (c:IsType(TYPE_FIELD) or
		(Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsType(TYPE_CONTINUOUS)))
end
function cm.sp(c,e,tp)
	return c:IsSetCard(0x92c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,2)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dbg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if #dbg>=2 then
		local dg1=dbg:RandomSelect(tp,2)
		local tchk=c:IsAbleToHand() and c:IsRelateToEffect(e)
		if Duel.SendtoGrave(dg1,REASON_EFFECT+REASON_DISCARD)==2 
			and tchk and Duel.SendtoHand(c,tp,REASON_EFFECT)>0 
			and c:IsLocation(LOCATION_HAND) then 
			Duel.BreakEffect()
			Duel.Readjust()
			local zg=Duel.GetMatchingGroup(cm.pf,tp,LOCATION_DECK,0,nil,tp)
			if #zg==0 then return false end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local vc=Duel.SelectMatchingCard(tp,cm.pf,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
			if vc==nil or not vc then return false end
			if vc:IsType(TYPE_FIELD) then 
				Duel.MoveToField(vc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			else 
				Duel.MoveToField(vc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
			end
			Duel.Readjust()
			if vc:GetLocation()~=LOCATION_SZONE then return false end
			Duel.BreakEffect()
			Duel.Readjust()
			local loc=LOCATION_DECK+LOCATION_GRAVE
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			local spg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.sp),tp,loc,0,nil,e,tp)
			if ft==0 or #spg==0 then return false end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=spg:Select(tp,1,1,nil)
			if #sg==0 then return false end
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		end
	end
end
--Effect 2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end


