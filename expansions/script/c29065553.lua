--方舟骑士团-陈·游龙
function c29065553.initial_effect(c) 
	c:EnableCounterPermit(0x10af)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,4)
	c:EnableReviveLimit() 
	--add 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_CHAINING) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c29065553.chencon)
	e1:SetCondition(c29065553.adcon) 
	e1:SetOperation(c29065553.adop) 
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c29065553.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)	
	--Destroy 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c29065553.chencon)
	e2:SetCondition(c29065553.dscon) 
	e2:SetOperation(c29065553.dsop) 
	c:RegisterEffect(e2)	
end
c29065553.assault_name=29065508
function c29065553.chencon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
function c29065553.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsCode,1,nil,29065508) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
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
