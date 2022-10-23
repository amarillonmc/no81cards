--血裔的领主 御影零夜
function c33201060.initial_effect(c) 
	c:EnableCounterPermit(0x32b)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)   
	e1:SetCountLimit(1,33201060+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33201060.spcon) 
	e1:SetOperation(c33201060.spop) 
	c:RegisterEffect(e1) 
	--set 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,33211060) 
	e2:SetTarget(c33201060.sttg) 
	e2:SetOperation(c33201060.stop) 
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
c33201060.VHisc_Vampire=true 
function c33201060.srlfil(c) 
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsRace(RACE_ZOMBIE) and c:IsReleasable()  
end 
function c33201060.srlgck(g) 
	return Duel.GetMZoneCount(tp,g)>0   
end 
function c33201060.spcon(e,c) 
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c33201060.srlfil,tp,LOCATION_HAND+LOCATION_MZONE,0,c) 
	return g:CheckSubGroup(c33201060.srlgck,2,2) 
end
function c33201060.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c33201060.srlfil,tp,LOCATION_HAND+LOCATION_MZONE,0,c)  
	local rg=g:SelectSubGroup(tp,c33201060.srlgck,false,2,2) 
	Duel.Release(rg,REASON_COST) 
end  
function c33201060.stfil(c) 
	return c:IsCode(33201052) and c:IsSSetable() 
end 
function c33201060.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33201060.stfil,tp,LOCATION_DECK,0,1,nil) end 
end 
function c33201060.stop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c33201060.stfil,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end 
