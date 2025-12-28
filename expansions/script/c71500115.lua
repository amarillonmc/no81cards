--预言术
function c71500115.initial_effect(c)
	aux.AddSetNameMonsterList(c,0x78f1) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c71500115.cost)
	e1:SetTarget(c71500115.target)
	e1:SetOperation(c71500115.activate)
	c:RegisterEffect(e1)
	--sort decktop
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c71500115.sdcost)
	e2:SetTarget(c71500115.sdtg)
	e2:SetOperation(c71500115.sdop)
	c:RegisterEffect(e2)
end
function c71500115.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) 
end
function c71500115.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71500115,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsCanRemoveCounter(tp,1,1,0x78f1,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x78f1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c) 
	return c:IsLocation(LOCATION_EXTRA) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c71500115.filter(c,e,tp)
	return true 
end 
function c71500115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp) 
		local mg2=nil 
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c71500115.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) 
end
function c71500115.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	::cancel::
	local mg=Duel.GetRitualMaterial(tp) 
	local mg2=nil 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c71500115.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if mg2 then
			mg:Merge(mg2)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure() 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1) 
		e1:SetLabel(Duel.GetTurnCount())  
		e1:SetCondition(c71500115.thcon) 
		e1:SetOperation(c71500115.thop) 
		e1:SetReset(RESET_PHASE+PHASE_END,2)  
		Duel.RegisterEffect(e1,tp)
	end
end
function c71500115.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end 
function c71500115.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,71500115)
	local code=Duel.AnnounceCard(tp) 
	local dc=Duel.TossDice(tp,1)  
	local g=Duel.GetDecktopGroup(tp,dc) 
	if g:GetCount()>=dc then 
		Duel.ConfirmDecktop(tp,dc) 
		if g:IsExists(Card.IsCode,1,nil,code) then 
			Duel.SendtoHand(g,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,g) 
		end 
	end 
end  
function c71500115.sdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x78f1,1,REASON_COST) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1) 
	Duel.RemoveCounter(tp,1,1,0x78f1,1,REASON_COST) 
end
function c71500115.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5 end
end
function c71500115.sdop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5
	if not b1 and not b2 then return end
	local op=nil
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(71500115,1),aux.Stringid(71500115,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(71500115,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(71500115,2))+1
	end
	local p=op==0 and tp or 1-tp
	Duel.SortDecktop(tp,p,5)
end

