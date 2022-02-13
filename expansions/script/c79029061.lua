--啸岚寒域 峰巅圣女
local m=79029061
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.condition1)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
	--Effect 2 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+100)
	e1:SetTarget(cm.rtg)
	e1:SetOperation(cm.rtop)
	c:RegisterEffect(e1) 
	--Effect 3 
	--Effect 4 
	--Effect 5 
end
cm.named_with_KarlanTrade=true 
--Effect 1
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler().named_with_KarlanTrade
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--Effect 2
function cm.filter5(c,e,tp)
	return c.named_with_KarlanTrade 
end
function cm.filter7(c)
	return c:IsFaceup() and c.named_with_KarlanTrade and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND
	if Duel.IsExistingMatchingCard(cm.filter7,tp,LOCATION_ONFIELD,0,1,nil) then
		loc=loc+LOCATION_DECK
	end
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)  
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,loc,0,1,nil,cm.filter5,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function cm.rtop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND
	if Duel.IsExistingMatchingCard(cm.filter7,tp,LOCATION_ONFIELD,0,1,nil) then
		loc=loc+LOCATION_DECK
	end
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,loc,0,1,1,nil,cm.filter5,e,tp,mg,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat) 
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end   
end
--Effect 3 
--Effect 4 
--Effect 5   
