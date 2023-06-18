--古战士巡风
function c91000336.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c91000336.filter,nil,nil,c91000336.matfilter,true) 
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,91000336)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
	and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end) 
	c:RegisterEffect(e1)  
	--to g 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end) 
	e2:SetTarget(c91000336.sptg) 
	e2:SetOperation(c91000336.spop) 
	c:RegisterEffect(e2)  
	--r
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(2) 
	e3:SetCondition(function(e) 
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end) 
	e3:SetCost(c91000336.atkcost) 
	e3:SetOperation(c91000336.atkop) 
	c:RegisterEffect(e3)
	--ri 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_RELEASE) 
	e4:SetProperty(EFFECT_FLAG_DELAY)  
	e4:SetCountLimit(1,29100336) 
	e4:SetCondition(function(e) 
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end) 
	e4:SetTarget(c91000336.ritg) 
	e4:SetOperation(c91000336.riop) 
	c:RegisterEffect(e4)
	--special summon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(c91000336.spccost)
	e0:SetOperation(c91000336.spcop)
	c:RegisterEffect(e0)   
	if not c91000336.global_check then
		c91000336.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c91000336.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end
c91000336.SetCard_Dr_AcWarrior=true 
function c91000336.checkop(e,tp,eg,ep,ev,re,r,rp) 
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		Duel.RegisterFlagEffect(rp,91000336,RESET_PHASE+PHASE_END,0,0)  
	end  
end
function c91000336.spccost(e,c,tp)
	return Duel.GetFlagEffect(tp,91000336)==0 
end
function c91000336.spcop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(c91000336.actlimit)
	Duel.RegisterEffect(e2,tp) 
end
function c91000336.actlimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) 
end
function c91000336.filter(c,e,tp,chk)
	return c:IsLevel(10) and c:IsType(TYPE_RITUAL)  
end
function c91000336.matfilter(c,e,tp,chk)
	return not chk or true 
end 
function c91000336.thfil(c) 
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and c:IsLevel(10)   
end 
function c91000336.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91000336.tgfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end 
function c91000336.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c91000336.tgfil,tp,LOCATION_DECK,0,nil)   
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoGrave(sg,tp,REASON_EFFECT)  
	end 
end 
function c91000336.spfil(c,e,tp) 
	return c:IsLevel(10) and c:IsCanBeSpecialSummoned(e,0,tp,TRUE,TRUE,POS_FACEDOWN_DEFENSE) 
end 
function c91000336.spgck(g,e,tp) 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and g:GetCount()>1 then return false end 
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount()   
end 
function c91000336.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsLevel(10) end,tp,LOCATION_MZONE,0,nil) 
	local g=Duel.GetMatchingGroup(c91000336.spfil,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return x>0 and g:CheckSubGroup(c91000336.spgck,1,x,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c91000336.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsLevel(10) end,tp,LOCATION_MZONE,0,nil) 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then x=1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=x then x=Duel.GetLocationCount(tp,LOCATION_MZONE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c91000336.spfil,tp,LOCATION_GRAVE,0,1,x,nil,e,tp)
	if g1:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g1:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			tc:RegisterFlagEffect(91000336,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			tc=g1:GetNext()
		end
		Duel.SpecialSummonComplete()
		g1:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)		
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g1)
		e1:SetCondition(c91000336.rmcon)
		e1:SetOperation(c91000336.rmop)
		Duel.RegisterEffect(e1,tp)
	end
end 
function c91000336.rmfilter(c,fid)
	return c:GetFlagEffectLabel(91000336)==fid
end
function c91000336.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	return  g:IsExists(c91000336.rmfilter,1,nil,e:GetLabel()) and Duel.GetTurnCount()~=e:GetHandler():GetTurnID()
end
function c91000336.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c91000336.rmfilter,nil,e:GetLabel())
	Duel.SendtoGrave(tg,REASON_EFFECT)
end
function c91000336.atkcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.Release(g,REASON_COST) 
end 
function c91000336.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetValue(1000) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_UPDATE_DEFENSE) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetValue(1000) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp) 
end 
function c91000336.hspfil(c,e,tp) 
	return ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)) or c:IsSummonable(true,nil)) and c:IsLevel(10)  
end 
function c91000336.ritg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c91000336.hspfil,tp,LOCATION_HAND,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end 
function c91000336.riop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c91000336.hspfil,tp,LOCATION_HAND,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst()  
		local op=0 
		local b1=tc:IsSummonable(true,nil) 
		local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		if b1 and b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(91000336,1),aux.Stringid(91000336,2))
		elseif b1 then 
			op=Duel.SelectOption(tp,aux.Stringid(91000336,1)) 
		elseif b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(91000336,2))+1 
		end 
		if op==0 then 
			Duel.Summon(tp,tc,true,nil) 
		elseif op==1 then 
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)  
		end 
	end 
end 


