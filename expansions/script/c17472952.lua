--域控·咏水
function c17472952.initial_effect(c) 
	--link summon
	aux.AddLinkProcedure(c,nil,3,99,c17472952.lcheck)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(c17472952.spcost)
	c:RegisterEffect(e1)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCondition(c17472952.hspcon)
	e1:SetTarget(c17472952.hsptg)
	e1:SetOperation(c17472952.hspop)
	c:RegisterEffect(e1)
	--xx
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE)   
	e2:SetCondition(c17472952.xxcon)
	e2:SetTarget(c17472952.xxtg) 
	e2:SetOperation(c17472952.xxop)
	c:RegisterEffect(e2)
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
	local e4=e2:Clone() 
	e4:SetCode(EVENT_MSET) 
	c:RegisterEffect(e4)  
	--ind
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(function(e,c)
	return not c:IsType(TYPE_LINK) end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,te)
	return te:IsActiveType(TYPE_MONSTER) and not te:GetOwner():IsType(TYPE_LINK) end)
	c:RegisterEffect(e1) 
end
function c17472952.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end 
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_LINK)
	return g:GetClassCount(Card.GetCode)>=3 
end
function c17472952.lcheck(g)
	return g:GetClassCount(Card.GetRace)==g:GetCount() and g:GetClassCount(Card.GetAttribute)==g:GetCount()
end
function c17472952.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x4b1) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler())>0
end
function c17472952.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c17472952.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function c17472952.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c17472952.spfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c17472952.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function c17472952.xxcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)  
end 
function c17472952.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if chk==0 then return g:GetCount()>0 end 
end 
function c17472952.lkfil(c,e,tp) 
	return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end 
function c17472952.cotfil(c) 
	return c:IsType(TYPE_LINK) or c:IsSetCard(0x4b1) 
end 
function c17472952.xxop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()  
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA) 
	local x=Duel.GetMatchingGroup(c17472952.cotfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if g:GetCount()>0 and x>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17472952,0))
		local xx=Duel.AnnounceLevel(tp,1,x)
		local xg=g:RandomSelect(tp,xx)
		Duel.ConfirmCards(tp,xg)
		Duel.BreakEffect() 
		local b1=Duel.GetFlagEffect(tp,17472952)==0 and xg:Filter(Card.IsAbleToRemove,nil):GetCount()>0 
		local b2=Duel.GetFlagEffect(tp,27472952)==0 and xg:Filter(c17472952.lkfil,nil,e,tp):GetCount()>0
		local b3=Duel.GetFlagEffect(tp,37472952)==0 and c:IsRelateToEffect(e) 
		local xtable={aux.Stringid(17472952,4)} 
		if b1 then table.insert(xtable,aux.Stringid(17472952,1)) end 
		if b2 then table.insert(xtable,aux.Stringid(17472952,2)) end 
		if b3 then table.insert(xtable,aux.Stringid(17472952,3)) end 
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
		if xtable[op]==aux.Stringid(17472952,1) then 
			local rg=xg:Filter(Card.IsAbleToRemove,nil):Select(tp,1,1,nil) 
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			Duel.RegisterFlagEffect(tp,17472952,RESET_PHASE+PHASE_END,0,1)
		end 
		if xtable[op]==aux.Stringid(17472952,2) then  
			local tc=xg:Filter(c17472952.lkfil,nil,e,tp):Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
			Duel.RegisterFlagEffect(tp,27472952,RESET_PHASE+PHASE_END,0,1)
		end  
		if xtable[op]==aux.Stringid(17472952,3) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			c:RegisterEffect(e1) 
			--ind
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(function(e,c)
			return c:IsType(TYPE_LINK) end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			c:RegisterEffect(e1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT) 
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(function(e,te)
			return te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsType(TYPE_LINK) end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			c:RegisterEffect(e1)
			Duel.RegisterFlagEffect(tp,37472952,RESET_PHASE+PHASE_END,0,1)
		end 
		Duel.ShuffleExtra(1-tp)
	end 
end 


