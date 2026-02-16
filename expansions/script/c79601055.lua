
--幽冥战士 萨兰斯
local s,id,o=GetID()
function s.initial_effect(c)
	--No Tribute Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1)
	--Special Summon and Xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--Grant Pierce
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetCondition(s.efcon)
	c:RegisterEffect(e3)
	--Counter for restriction
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or (c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK))
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST)
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.exgfilter(c,mg,mc)
	return mg:CheckSubGroup(s.exgselect,1,#mg,c,mc)
end
function s.exgselect(g,exc,mc)
	return g:IsContains(mc) and exc:IsXyzSummonable(g,#g,#g)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local exg=Duel.GetMatchingGroup(s.exgfilter,tp,LOCATION_EXTRA,0,nil,mg,c)
		if #exg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()					  
			if exg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sc=exg:Select(tp,1,1,nil):GetFirst()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local msg=mg:SelectSubGroup(tp,s.exgselect,false,1,#mg,sc,c)
				Duel.XyzSummon(tp,sc,msg,#msg,#msg)
			end
		end
	end
end
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0xd70)
end
