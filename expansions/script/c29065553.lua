--方舟骑士-陈·游龙
c29065553.named_with_Arknight=1
function c29065553.initial_effect(c) 
	c:EnableReviveLimit() 
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c29065553.splimit)
	c:RegisterEffect(e0)
	--add 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_CHAINING) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c29065553.adcon) 
	e1:SetOperation(c29065553.adop) 
	c:RegisterEffect(e1)	
	--Destroy 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c29065553.dscon) 
	e2:SetOperation(c29065553.dsop) 
	c:RegisterEffect(e2)	
end
c29065553.assault_name=29065508
function c29065553.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return (sc:IsSetCard(0x87af) or (_G["c"..sc:GetCode()] and  _G["c"..sc:GetCode()].named_with_Arknight)) 
end
function c29065553.adcon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	return c:IsCanAddCounter(0x10af,1) and rp==1-tp 
end 
function c29065553.adop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	c:AddCounter(0x10af,1) 
end 
function c29065553.dscon(e,tp,eg,ep,ev,re,r,rp) 
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local c=e:GetHandler()  
	return c:IsCanRemoveCounter(tp,0x10af,3,REASON_EFFECT) and rp==1-tp and (LOCATION_HAND+LOCATION_ONFIELD)&loc~=0
end 
function c29065553.dsfil(c,s,p) 
	local seq=c:GetSequence()
	return s<5 and seq<5 and math.abs(seq-s)==1 and c:IsControler(p)
end
function c29065553.dsop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local rc=re:GetHandler()
	Duel.Hint(HINT_CARD,0,29065553) 
	if not c:IsCanRemoveCounter(tp,0x10af,3,REASON_EFFECT) then return end 
	c:RemoveCounter(tp,0x10af,3,REASON_EFFECT)  
	local g=Group.CreateGroup()
	if rc:IsOnField() then 
	local seq=rc:GetSequence() 
	local p=rc:GetControler()
	g=Duel.GetMatchingGroup(c29065553.dsfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,seq,p)  
	end 
	Duel.Destroy(rc,REASON_EFFECT)  
	if g:GetCount()>0 then  
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
	end 
end 




