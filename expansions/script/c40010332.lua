--龙刻魔道士 卢亚德
local m=40010332
local cm=_G["c"..m]
cm.named_with_DragWizard=1
function cm.Crimsonmoon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_DragWizard
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Effect 1
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_CHANGE_LEVEL)
	e11:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--Effect 2 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1) 
end
--Effect 1
--Effect 2
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabel(Duel.GetTurnCount()+1)
		e2:SetLabelObject(c)
		e2:SetCondition(cm.retcon)
		e2:SetOperation(cm.retop)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.spfilter(c)
	return c.named_with_DragWizard and not c:IsCode(m)
end
function cm.getcheck(c)
	return c:IsLevel(1) and c:IsAbleToDeck()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local exg=Duel.GetMatchingGroup(cm.getcheck,tp,LOCATION_GRAVE,0,mg)
		local rfc=Card.GetRitualLevel
		function Card.GetRitualLevel(tc,rc)
			if exg:IsContains(tc) then
				return 3
			else
				return rfc(tc,rc)
			end
		end
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_DECK,0,1,nil,cm.spfilter,e,tp,mg,exg,Card.GetOriginalLevel,"Equal")
		Card.GetRitualLevel=rfc
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local exg=Duel.GetMatchingGroup(cm.getcheck,tp,LOCATION_GRAVE,0,mg)
	local rfc=Card.GetRitualLevel
	function Card.GetRitualLevel(tc,rc)
		if exg:IsContains(tc) then
			return 3
		else
			return rfc(tc,rc)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_DECK,0,1,1,nil,cm.spfilter,e,tp,mg,exg,Card.GetOriginalLevel,"Equal")
	local tc=g:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		if exg then
			mg:Merge(exg)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetOriginalLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetOriginalLevel(),tp,tc,tc:GetOriginalLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then Card.GetRitualLevel=rfc return end
		tc:SetMaterial(mat)
		local mat1=Group.__band(exg,mat)
		Duel.SendtoDeck(mat1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		mat:Sub(mat1)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	end
		Card.GetRitualLevel=rfc
end