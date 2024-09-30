--罗星姬 天龙座
local s,id,o=GetID()
function s.initial_effect(c)
    --Synchro summon
	aux.AddSynchroProcedure(c,s.filter,aux.NonTuner(s.filter),1,1)
	c:EnableReviveLimit()
    --move 
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetTarget(s.mvtg)
	e1:SetOperation(s.mvop)
	c:RegisterEffect(e1)
end
function s.filter(c) 
	return c:GetSequence()==4 or c:GetSequence()==0
end
function s.distg(e,c)
	local seq=e:GetHandler():GetSequence()
	local tp=e:GetHandlerPlayer()
	return aux.GetColumn(c,tp)==seq
end
function s.mvfil1(c) 
	return c:GetSequence()==4
end
function s.mvfil2(c) 
	return c:GetSequence()>=0 and c:GetSequence()<4   
end
function s.mvtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g1=Duel.GetMatchingGroup(s.mvfil1,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(s.mvfil2,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g1:GetCount()>0 or g2:GetCount()>0 end   
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end 
function s.mvop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(s.mvfil1,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(s.mvfil2,tp,0,LOCATION_MZONE,nil) 
    local g=Duel.GetMatchingGroup(function(c) return c:GetSequence()==4 end,tp,0,LOCATION_MZONE,nil)
    if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_RULE)
	end
    if g2:GetCount()>0 then 
		local a=3
		while a>=0 do 
			local tc=g2:Filter(function(c,seq) return c:GetSequence()==seq end,nil,a):GetFirst()
			if tc then 
				Duel.MoveSequence(tc,a+1)
			end 
			a=a-1 
		end 
	end
end