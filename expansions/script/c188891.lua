local m=188891
local cm=_G["c"..m]
cm.name="乐土永狱"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,e,tp,m1,m2)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0xcaa) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	m2=m2:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then m1=m1:Filter(c.mat_filter,nil,tp) end
	if c.mat_filter then m2=m2:Filter(c.mat_filter,nil,tp) end
	if #m1==0 then return false end
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,c:GetLevel(),"Equal")
	local res=m2:CheckSubGroup(cm.fselect,0,c:GetLevel(),c,m1)
	aux.GCheckAdditional=nil
	return res
end
function cm.fselect(g,mc,mg)
	local xg=g:Clone()
	xg:Merge(mg)
	return xg:CheckWithSumEqual(Card.GetRitualLevel,mc:GetLevel(),1,xg:GetCount(),mc)
end
function cm.filter(c,e,tp,mg)
	return c:IsSetCard(0xcaa) and Duel.IsPlayerCanRelease(tp,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp,Group.FromCards(c),mg)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.mfilter(g,ritc,matc)
	return g:IsContains(matc) and Duel.GetMZoneCount(tp,g,tp)>0 and aux.RitualCheckEqual(g,ritc,ritc:GetLevel())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg):GetFirst()
	if mc and Duel.SpecialSummon(mc,0,tp,tp,false,false,POS_FACEUP)==1 and mc:IsLocation(LOCATION_MZONE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,Group.FromCards(mc),mg):GetFirst()
		local mgf=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		Duel.SetSelectedCard(mc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mgf:SelectSubGroup(tp,cm.mfilter,false,1,99,tc,mc)
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_RITUAL) and math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))>=2000
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
