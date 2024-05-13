--晶化血裔 吉尔雷比斯
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x32b)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)   
	e1:SetCountLimit(1,33201068+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon) 
	e1:SetOperation(s.spop) 
	c:RegisterEffect(e1) 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCondition(s.ctcon)
	e0:SetOperation(s.ctop)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	--set 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,33211068) 
	e2:SetTarget(s.sttg) 
	e2:SetOperation(s.stop) 
	c:RegisterEffect(e2)  
	--atk  
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE) 
	e3:SetCode(EFFECT_UPDATE_ATTACK) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x32b)>=5 end) 
	e3:SetValue(500) 
	c:RegisterEffect(e3)
end 
s.VHisc_Vampire=true 

--e1
function s.srlfil(c) 
	return c:IsLocation(LOCATION_GRAVE) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()  
end 
function s.srlgck(g) 
	return Duel.GetMZoneCount(tp,g)>0   
end 
function s.spcon(e,c) 
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(s.srlfil,tp,LOCATION_GRAVE,0,c) 
	return g:CheckSubGroup(s.srlgck,2,2) 
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.srlfil,tp,LOCATION_GRAVE,0,c)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,s.srlgck,false,2,2) 
	Duel.Remove(rg,POS_FACEUP,REASON_COST) 
	local rec=0
	for tc in aux.Next(rg) do
		rec=rec+tc:GetAttack()
	end
	e:SetLabel(rec)
end  
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	return re==te
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local rec=re:GetLabel()
	Duel.Recover(tp,rec,REASON_EFFECT)
	re:SetLabel(0)
end


--e2
function s.stfil(c) 
	return c.VHisc_Vampire and c:IsSSetable() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end 
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.stfil,tp,LOCATION_GRAVE,0,1,nil) end 
end 
function s.stop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.stfil,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 and (tc:IsType(TYPE_QUICKPLAY) or tc:IsType(TYPE_TRAP)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end 

