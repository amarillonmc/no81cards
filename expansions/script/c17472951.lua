--域控·颂火
function c17472951.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c17472951.ffilter,2,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION) 
	c:RegisterEffect(e1)
	--ind
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(function(e,c)
	return not c:IsType(TYPE_FUSION) end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,te)
	return te:IsActiveType(TYPE_MONSTER) and not te:GetOwner():IsType(TYPE_FUSION) end)
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE)   
	e2:SetCondition(c17472951.xxcon)
	e2:SetTarget(c17472951.xxtg) 
	e2:SetOperation(c17472951.xxop)
	c:RegisterEffect(e2)
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
	local e4=e2:Clone() 
	e4:SetCode(EVENT_MSET) 
	c:RegisterEffect(e4)  
end
function c17472951.matchfilter(c,attr,race)
	return c:IsFusionAttribute(attr) and c:IsRace(race)
end
function c17472951.ffilter(c,fc,sub,mg,sg)
	return (not sg or sg:FilterCount(aux.TRUE,c)==0
		or (sg:IsExists(c17472951.matchfilter,#sg-1,c,c:GetFusionAttribute(),c:GetRace()) and not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))) and c:IsSummonLocation(LOCATION_EXTRA) and not c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c17472951.xxcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)  
end 
function c17472951.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if chk==0 then return g:GetCount()>0 end 
end 
function c17472951.fusfil(c,e,tp,mg) 
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg)
end 
function c17472951.xxop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()  
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if g:GetCount()>0 then  
		Duel.ConfirmCards(tp,g)
		Duel.BreakEffect() 
		local b1=Duel.GetFlagEffect(tp,17472951)==0 and g:Filter(Card.IsAbleToRemove,nil):GetCount()>0
		local mg1=Duel.GetFusionMaterial(tp,LOCATION_MZONE+LOCATION_GRAVE):Filter(Card.IsAbleToRemove,nil):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
		local mg2=Duel.GetFusionMaterial(1-tp,LOCATION_MZONE+LOCATION_GRAVE):Filter(Card.IsAbleToRemove,nil):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e) 
		mg1:Merge(mg2) 
		local b2=Duel.GetFlagEffect(tp,27472951)==0 and g:Filter(c17472951.fusfil,nil,e,tp,mg1):GetCount()>0
		local b3=Duel.GetFlagEffect(tp,37472951)==0 and c:IsRelateToEffect(e) 
		local xtable={aux.Stringid(17472951,4)} 
		if b1 then table.insert(xtable,aux.Stringid(17472951,1)) end 
		if b2 then table.insert(xtable,aux.Stringid(17472951,2)) end 
		if b3 then table.insert(xtable,aux.Stringid(17472951,3)) end 
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
		if xtable[op]==aux.Stringid(17472951,1) then 
			local rg=g:Filter(Card.IsAbleToRemove,nil):Select(tp,1,1,nil) 
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			Duel.RegisterFlagEffect(tp,17472951,RESET_PHASE+PHASE_END,0,1)
		end 
		if xtable[op]==aux.Stringid(17472951,2) then 
			local mg1=Duel.GetFusionMaterial(tp,LOCATION_MZONE+LOCATION_GRAVE):Filter(Card.IsAbleToRemove,nil):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
			local mg2=Duel.GetFusionMaterial(1-tp,LOCATION_MZONE+LOCATION_GRAVE):Filter(Card.IsAbleToRemove,nil):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e) 
			mg1:Merge(mg2) 
			local tc=g:Filter(c17472951.fusfil,nil,e,tp,mg1):Select(tp,1,1,nil):GetFirst() 
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
			Duel.RegisterFlagEffect(tp,27472951,RESET_PHASE+PHASE_END,0,1)
		end  
		if xtable[op]==aux.Stringid(17472951,3) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			c:RegisterEffect(e1)
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_UPDATE_DEFENSE) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			c:RegisterEffect(e1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetValue(function(e,re,r,rp)
			return bit.band(r,REASON_EFFECT)~=0 end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			Duel.RegisterFlagEffect(tp,37472951,RESET_PHASE+PHASE_END,0,1)
		end 
		Duel.ShuffleExtra(1-tp)
	end 
end 


