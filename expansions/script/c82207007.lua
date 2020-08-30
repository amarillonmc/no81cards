local m=82207007
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end 
function cm.filter(c,e,tp)  
	return c:IsType(TYPE_RITUAL) 
end  
function cm.rcheck(tp,g,c)  
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1  
end  
function cm.rgcheck(g)  
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local mg=Duel.GetRitualMaterial(tp)   
		aux.RCheckAdditional=cm.rcheck  
		aux.RGCheckAdditional=cm.rgcheck  
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_DECK,0,1,nil,cm.filter,e,tp,mg,nil,Card.GetLevel,"Equal")  
		aux.RCheckAdditional=nil  
		aux.RGCheckAdditional=nil  
		return res  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local m=Duel.GetRitualMaterial(tp)  
	local dg=nil  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	aux.RCheckAdditional=cm.rcheck  
	aux.RGCheckAdditional=cm.rgcheck  
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_DECK,0,1,1,nil,cm.filter,e,tp,m,nil,Card.GetLevel,"Equal")  
	local tc=tg:GetFirst()  
	if tc then  
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)   
		if tc.mat_filter then  
			mg=mg:Filter(tc.mat_filter,tc,tp)  
		else  
			mg:RemoveCard(tc)  
		end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)  
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")  
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")  
		aux.GCheckAdditional=nil  
		if not mat or mat:GetCount()==0 then  
			aux.RCheckAdditional=nil  
			aux.RGCheckAdditional=nil  
			return  
		end  
		tc:SetMaterial(mat)   
		Duel.ReleaseRitualMaterial(mat)  
		Duel.BreakEffect()  
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)  
		tc:CompleteProcedure()  
		Duel.BreakEffect()
		local lv=tc:GetOriginalLevel()
		Duel.Damage(tp,lv*1000,REASON_EFFECT)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(m,0))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetRange(LOCATION_MZONE) 
		e3:SetCountLimit(1)  
		e3:SetCode(EVENT_PHASE+PHASE_STANDBY)  
		e3:SetCondition(cm.damcon)  
		e3:SetOperation(cm.damop)  
		tc:RegisterEffect(e3)   
	end  
	aux.RCheckAdditional=nil  
	aux.RGCheckAdditional=nil  
end  
function cm.damcon(e,tp)  
	return Duel.GetTurnPlayer()==tp 
end  
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(tp,aux.Stringid(m,0))
	Duel.Damage(tp,1000,REASON_EFFECT)  
end  